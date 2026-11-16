# FmACP — minimal Agent Client Protocol client for testing ACP agents.
#
# The client connects to an ACP server over one of two mutually exclusive
# transports — spawning the agent process (stdio) with -Command, or connecting
# over TCP with -Port — speaks JSON-RPC 2.0 with newline-delimited framing,
# auto-answers permission requests according to the configured policy, and
# streams session updates to the console. It is a test harness, not a
# production client: persistence, modes UI, and manual permission prompts are
# deliberately out of scope.

function Connect-AcpAgent {
    <#
    .SYNOPSIS
        Connects to an ACP agent over stdio or TCP and performs the
        initialize handshake.
    .EXAMPLE
        # stdio: spawn the bundled agent with environment variables
        $conn = Connect-AcpAgent -Environment @{ FM_BRIDGE_URL = 'http://127.0.0.1:1977' }
    .EXAMPLE
        # stdio: explicit command
        $conn = Connect-AcpAgent -Command node -ArgumentList @('/path/agent.js')
    .EXAMPLE
        # tcp: connect to an agent listening with '--tcp <port>'
        $conn = Connect-AcpAgent -Port 1984
    #>
    [CmdletBinding(DefaultParameterSetName = 'Stdio')]
    param(
        [Parameter(ParameterSetName = 'Stdio', Position = 0)]
        [string]$Command,
        [Parameter(ParameterSetName = 'Stdio')]
        [string[]]$ArgumentList,
        [Parameter(ParameterSetName = 'Stdio')]
        [hashtable]$Environment,
        [Parameter(ParameterSetName = 'Stdio')]
        [string]$WorkingDirectory = (Get-Location).Path,
        [Parameter(Mandatory, ParameterSetName = 'Tcp')]
        [int]$Port,
        [Parameter(ParameterSetName = 'Tcp')]
        [string]$AgentHost = '127.0.0.1',
        [ValidateSet('Allow', 'Reject')]
        [string]$PermissionPolicy = 'Allow',
        [int]$InitializeTimeoutSeconds = 30
    )

    if ($PSCmdlet.ParameterSetName -eq 'Stdio') {
        if (-not $Command) { $Command = 'node' }
        if (-not $ArgumentList -or $ArgumentList.Count -eq 0) {
            $bundle = [System.IO.Path]::GetFullPath(
                (Join-Path $PSScriptRoot '../agent/dist/cli.js')
            )
            if (-not (Test-Path $bundle)) {
                throw "Agent bundle not found at '$bundle'. Build it with 'pnpm build' in fm-agent-harness/agent, or pass -Command and -ArgumentList."
            }
            $ArgumentList = @($bundle)
        }

        $psi = [System.Diagnostics.ProcessStartInfo]::new()
        $psi.FileName = $Command
        foreach ($argument in $ArgumentList) {
            $null = $psi.ArgumentList.Add($argument)
        }
        $psi.WorkingDirectory = $WorkingDirectory
        $psi.RedirectStandardInput = $true
        $psi.RedirectStandardOutput = $true
        $psi.RedirectStandardError = $false
        $psi.UseShellExecute = $false
        if ($Environment) {
            foreach ($key in $Environment.Keys) {
                $psi.EnvironmentVariables[[string]$key] = [string]$Environment[$key]
            }
        }

        $process = [System.Diagnostics.Process]::new()
        $process.StartInfo = $psi
        $null = $process.Start()
        $reader = $process.StandardOutput
        $writer = $process.StandardInput
        $transport = 'stdio'
        $transportTarget = $ArgumentList -join ' '
    }
    else {
        $client = [System.Net.Sockets.TcpClient]::new()
        try {
            $client.Connect($AgentHost, $Port)
        } catch {
            throw "Could not connect to the ACP server at ${AgentHost}:$Port. $($_.Exception.Message)"
        }
        $stream = $client.GetStream()
        # UTF8 without a BOM: the BOM bytes would corrupt the first JSON-RPC
        # frame for servers that parse lines strictly.
        $encoding = [System.Text.UTF8Encoding]::new($false)
        $reader = [System.IO.StreamReader]::new($stream, $encoding)
        $writer = [System.IO.StreamWriter]::new($stream, $encoding)
        $writer.AutoFlush = $true
        $writer.NewLine = "`n"
        $transport = 'tcp'
        $transportTarget = "${AgentHost}:$Port"
    }

    $state = [hashtable]::Synchronized(@{
        Queue = [System.Collections.Concurrent.ConcurrentQueue[string]]::new()
        Pending = [System.Collections.Concurrent.ConcurrentDictionary[int, System.Threading.Tasks.TaskCompletionSource[string]]]::new()
        SendLock = [System.Object]::new()
        PermissionPolicy = $PermissionPolicy
        Running = $true
        NextId = 1
        Sessions = [System.Collections.Concurrent.ConcurrentDictionary[string, object]]::new()
    })

    $readerHost = Start-AcpReaderLoop -Reader $reader -Writer $writer -State $state

    $connection = [PSCustomObject]@{
        Transport = $transport
        TransportTarget = $transportTarget
        Process = if ($transport -eq 'stdio') { $process } else { $null }
        TcpClient = if ($transport -eq 'tcp') { $client } else { $null }
        Reader = $reader
        Writer = $writer
        State = $state
        ReaderHost = $readerHost
        AgentInfo = $null
    }
    $connection.PSObject.TypeNames.Insert(0, 'FmACP.Connection')

    try {
        $init = Invoke-AcpRequest -Connection $connection -Method 'initialize' -Params @{
            protocolVersion = 1
            clientCapabilities = @{}
        } -TimeoutSeconds $InitializeTimeoutSeconds
    } catch {
        # The handshake failed: tear the transport down before surfacing it,
        # so a failed connect leaves no leaked sockets or processes.
        try { Disconnect-AcpAgent -Connection $connection } catch { }
        throw
    }

    $connection.AgentInfo = $init.result

    # Agents that require login advertise authMethods; ACP expects the client
    # to pick one and call authenticate before opening sessions.
    $authMethods = @($init.result.authMethods)
    if ($authMethods.Count -gt 0) {
        $methodId = $authMethods[0].id
        try {
            $null = Invoke-AcpRequest -Connection $connection -Method 'authenticate' -Params @{
                methodId = $methodId
            } -TimeoutSeconds $InitializeTimeoutSeconds
            Write-Host "Authenticated with agent method '$methodId'." -ForegroundColor DarkGray
        } catch {
            try { Disconnect-AcpAgent -Connection $connection } catch { }
            throw "The agent requires authentication (method '$methodId') and it failed: $($_.Exception.Message)"
        }
    }

    Write-Host "Connected ($transport $transportTarget): agent protocol v$($init.result.protocolVersion), agent '$($init.result.agentInfo.name)'" -ForegroundColor DarkGray
    return $connection
}

function New-AcpSession {
    <#
    .SYNOPSIS
        Creates an ACP session with the given working directory.
    .EXAMPLE
        $session = New-AcpSession $conn -Cwd ~/tmp/sandbox
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        $Connection,
        [string]$Cwd = (Get-Location).Path
    )
    $resolved = (Resolve-Path $Cwd).Path
    $response = Invoke-AcpRequest -Connection $Connection -Method 'session/new' -Params @{
        cwd = $resolved
        mcpServers = @()
    }
    $modeId = if ($response.result.modes -and $response.result.modes.currentModeId) {
        $response.result.modes.currentModeId
    } else {
        'unknown'
    }
    $now = (Get-Date).ToUniversalTime().ToString('o')
    $Connection.State.Sessions[$response.result.sessionId] = [PSCustomObject]@{
        SessionId = $response.result.sessionId
        Cwd = $resolved
        ModeId = $modeId
        CreatedAt = $now
        UpdatedAt = $now
    }
    return [PSCustomObject]@{
        SessionId = $response.result.sessionId
        Modes = $response.result.modes
    }
}

function Invoke-AcpPrompt {
    <#
    .SYNOPSIS
        Sends a prompt and streams the turn's updates to the console.
    .EXAMPLE
        $turn = Invoke-AcpPrompt $conn -SessionId $s.SessionId -Prompt 'List the files here.'
        $turn.StopReason
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        $Connection,
        [Parameter(Mandatory)]
        [string]$SessionId,
        [Parameter(Mandatory)]
        [string]$Prompt,
        [int]$TimeoutSeconds = 600
    )
    $state = $Connection.State
    if (-not $state.Running) {
        throw 'The agent process is not running.'
    }

    $id = $state.NextId
    $state.NextId = $id + 1
    $frame = @{
        jsonrpc = '2.0'
        id = $id
        method = 'session/prompt'
        params = @{
            sessionId = $SessionId
            prompt = @(@{ type = 'text'; text = $Prompt })
        }
    } | ConvertTo-Json -Compress -Depth 12

    $tcs = [System.Threading.Tasks.TaskCompletionSource[string]]::new(
        [System.Threading.Tasks.TaskCreationOptions]::RunContinuationsAsynchronously
    )
    $state.Pending[$id] = $tcs

    [System.Threading.Monitor]::Enter($state.SendLock)
    try {
        $Connection.Writer.WriteLine($frame)
    } catch {
        $removed = $null
        $null = $state.Pending.TryRemove($id, [ref]$removed)
        throw ("'session/prompt' failed on {0} {1}: the server closed the connection as the request was sent." -f $Connection.Transport, $Connection.TransportTarget)
    } finally {
        [System.Threading.Monitor]::Exit($state.SendLock)
    }

    $updates = [System.Collections.Generic.List[object]]::new()
    $text = [System.Text.StringBuilder]::new()
    $deadline = [DateTime]::UtcNow.AddSeconds($TimeoutSeconds)
    try {
        while (-not $tcs.Task.IsCompleted) {
            while (Receive-AcpUpdateLine -Connection $Connection -Updates $updates -Text $text) {
                # Drain everything currently queued.
            }
            if (-not $state.Running) {
                throw 'The agent process exited during the prompt turn.'
            }
            if ([DateTime]::UtcNow -gt $deadline) {
                throw "Prompt timed out after $TimeoutSeconds seconds."
            }
            Start-Sleep -Milliseconds 100
        }
        # Final drain of anything that raced in with the response.
        while (Receive-AcpUpdateLine -Connection $Connection -Updates $updates -Text $text) {
            # Drain.
        }
    } finally {
        if ($updates.Count -gt 0 -or $text.Length -gt 0) {
            Write-Host ''
        }
    }

    if ($tcs.Task.IsCanceled -or $tcs.Task.IsFaulted) {
        throw 'The agent exited before completing the prompt turn.'
    }
    $response = $tcs.Task.Result | ConvertFrom-Json
    if ($response.error) {
        throw "Prompt failed: $($response.error.message)"
    }

    [PSCustomObject]@{
        StopReason = $response.result.stopReason
        Text = $text.ToString()
        Updates = $updates
    }
}

function Set-AcpMode {
    <#
    .SYNOPSIS
        Switches the session permission mode ('ask' or 'auto-edit').
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        $Connection,
        [Parameter(Mandatory)]
        [string]$SessionId,
        [Parameter(Mandatory)]
        [string]$ModeId
    )
    $response = Invoke-AcpRequest -Connection $Connection -Method 'session/set_mode' -Params @{
        sessionId = $SessionId
        modeId = $ModeId
    }
    # Give the agent a moment to deliver the current_mode_update notification.
    $drained = 0
    while ($drained -lt 3) {
        Start-Sleep -Milliseconds 100
        while (Receive-AcpUpdateLine -Connection $Connection -Updates ([System.Collections.Generic.List[object]]::new()) -Text ([System.Text.StringBuilder]::new())) {
            $drained = 0
        }
        $drained += 1
    }
    return $response.result
}

function Send-AcpCancel {
    <#
    .SYNOPSIS
        Cancels the current prompt turn of a session.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        $Connection,
        [Parameter(Mandatory)]
        [string]$SessionId
    )
    $frame = @{
        jsonrpc = '2.0'
        method = 'session/cancel'
        params = @{ sessionId = $SessionId }
    } | ConvertTo-Json -Compress -Depth 6
    [System.Threading.Monitor]::Enter($Connection.State.SendLock)
    try { $Connection.Writer.WriteLine($frame) } finally {
        [System.Threading.Monitor]::Exit($Connection.State.SendLock)
    }
}

function Disconnect-AcpAgent {
    <#
    .SYNOPSIS
        Closes the transport (stdin for stdio, socket for TCP) and cleans up.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        $Connection
    )
    $Connection.State.Running = $false
    if ($Connection.Transport -eq 'stdio') {
        try { $Connection.Writer.Close() } catch { }
        if (-not $Connection.Process.WaitForExit(3000)) {
            $null = $Connection.Process.Kill($true)
        }
        $Connection.Process.Dispose()
    } else {
        try { $Connection.TcpClient.Close() } catch { }
    }
    try { $Connection.ReaderHost.Stop() } catch { }
    Write-Host 'Disconnected.' -ForegroundColor DarkGray
}

function Get-AcpAgent {
    <#
    .SYNOPSIS
        Reports the connection's state and the agent's advertised capabilities.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        $Connection
    )
    $agentInfo = $Connection.AgentInfo
    $capabilities = $agentInfo.agentCapabilities
    $sessionCapabilities = if ($capabilities.sessionCapabilities) {
        @($capabilities.sessionCapabilities.PSObject.Properties.Name)
    } else {
        @()
    }
    return [PSCustomObject]@{
        Running = $Connection.State.Running
        Transport = $Connection.Transport
        TransportTarget = $Connection.TransportTarget
        ProcessId = if ($Connection.Process) { $Connection.Process.Id } else { $null }
        ProtocolVersion = $agentInfo.protocolVersion
        LoadSession = [bool]($capabilities.loadSession)
        SessionCapabilities = $sessionCapabilities
        TrackedSessions = $Connection.State.Sessions.Count
    }
}

function Get-AcpSession {
    <#
    .SYNOPSIS
        Lists sessions. Queries the agent's session/list when advertised,
        otherwise reports locally tracked sessions.
    .EXAMPLE
        Get-AcpSession $conn | Format-Table SessionId, Cwd, ModeId
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        $Connection,
        [string]$Cwd,
        [ValidateSet('Auto', 'Remote', 'Local')]
        [string]$Source = 'Auto'
    )
    $sessionCapabilities = $Connection.AgentInfo.agentCapabilities.sessionCapabilities
    $remoteSupported = ($sessionCapabilities -and $sessionCapabilities.list)
    if ($Source -eq 'Remote' -and -not $remoteSupported) {
        throw 'The agent does not advertise sessionCapabilities.list; use -Source Local.'
    }

    if ($Source -in @('Auto', 'Remote') -and $remoteSupported) {
        $listParams = @{}
        if ($Cwd) { $listParams.cwd = (Resolve-Path $Cwd).Path }
        $response = Invoke-AcpRequest -Connection $Connection -Method 'session/list' -Params $listParams
        $results = @()
        foreach ($info in @($response.result.sessions)) {
            $tracked = $Connection.State.Sessions[$info.sessionId]
            $modeId = if ($tracked) { $tracked.ModeId } else { 'unknown' }
            $entry = [PSCustomObject]@{
                SessionId = $info.sessionId
                Cwd = $info.cwd
                ModeId = $modeId
                CreatedAt = $null
                UpdatedAt = $info.updatedAt
            }
            $Connection.State.Sessions[$info.sessionId] = $entry
            $results += $entry
        }
        return $results
    }

    $entries = @($Connection.State.Sessions.Values)
    if ($Cwd) {
        $resolved = (Resolve-Path $Cwd).Path
        $entries = @($entries | Where-Object { $_.Cwd -eq $resolved })
    }
    return $entries
}

function Get-AcpMode {
    <#
    .SYNOPSIS
        Reports the current permission mode of a session, refreshing from any
        queued mode notifications first.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        $Connection,
        [Parameter(Mandatory)]
        [string]$SessionId
    )
    $updates = [System.Collections.Generic.List[object]]::new()
    $text = [System.Text.StringBuilder]::new()
    while (Receive-AcpUpdateLine -Connection $Connection -Updates $updates -Text $text -Quiet) {
        # Drain queued notifications.
    }
    $entry = $Connection.State.Sessions[$SessionId]
    if (-not $entry) {
        throw "Session '$SessionId' is not tracked. Open it with New-AcpSession or list with Get-AcpSession."
    }
    return [PSCustomObject]@{
        SessionId = $SessionId
        ModeId = $entry.ModeId
    }
}

function Get-AcpUpdate {
    <#
    .SYNOPSIS
        Drains queued session/update notifications without sending anything.
    .EXAMPLE
        Get-AcpUpdate $conn -Show     # print and return
        Get-AcpUpdate $conn           # just return
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        $Connection,
        [switch]$Show
    )
    $updates = [System.Collections.Generic.List[object]]::new()
    $text = [System.Text.StringBuilder]::new()
    while (Receive-AcpUpdateLine -Connection $Connection -Updates $updates -Text $text -Quiet:(-not $Show)) {
        # Drain.
    }
    return $updates
}

function Remove-AcpSession {
    <#
    .SYNOPSIS
        Deletes a session via session/delete (requires the delete capability).
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        $Connection,
        [Parameter(Mandatory)]
        [string]$SessionId
    )
    $sessionCapabilities = $Connection.AgentInfo.agentCapabilities.sessionCapabilities
    if (-not ($sessionCapabilities -and $sessionCapabilities.delete)) {
        throw 'The agent does not advertise sessionCapabilities.delete.'
    }
    $null = Invoke-AcpRequest -Connection $Connection -Method 'session/delete' -Params @{
        sessionId = $SessionId
    }
    $removed = $null
    $null = $Connection.State.Sessions.TryRemove($SessionId, [ref]$removed)
    Write-Host "Session $SessionId deleted." -ForegroundColor DarkGray
}

# --- internals -----------------------------------------------------------

function Invoke-AcpRequest {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        $Connection,
        [Parameter(Mandatory)]
        [string]$Method,
        [object]$Params = @{},
        [int]$TimeoutSeconds = 120
    )
    $state = $Connection.State
    if (-not $state.Running) {
        throw 'The agent process is not running.'
    }
    $id = $state.NextId
    $state.NextId = $id + 1
    $frame = @{
        jsonrpc = '2.0'
        id = $id
        method = $Method
        params = $Params
    } | ConvertTo-Json -Compress -Depth 12

    $tcs = [System.Threading.Tasks.TaskCompletionSource[string]]::new(
        [System.Threading.Tasks.TaskCreationOptions]::RunContinuationsAsynchronously
    )
    $state.Pending[$id] = $tcs

    [System.Threading.Monitor]::Enter($state.SendLock)
    try {
        $Connection.Writer.WriteLine($frame)
    } catch {
        # The server closed the connection before (or while) the frame landed.
        $removed = $null
        $null = $state.Pending.TryRemove($id, [ref]$removed)
        $where = "$($Connection.Transport) $($Connection.TransportTarget)"
        throw ("'{0}' failed on {1}: the server closed the connection as the request was sent. " +
            "Check that an ACP agent is listening there and still running " +
            "(for the bundled agent: node dist/cli.js --tcp <port>, or spawn it with -Command).") -f $Method, $where
    } finally {
        [System.Threading.Monitor]::Exit($state.SendLock)
    }

    try {
        if (-not $tcs.Task.Wait([TimeSpan]::FromSeconds($TimeoutSeconds))) {
            $removed = $null
            $null = $state.Pending.TryRemove($id, [ref]$removed)
            throw "Timed out after $TimeoutSeconds seconds waiting for '$Method'."
        }
    } catch [System.AggregateException] {
        # The pending task was canceled: the server closed the connection.
        $removed = $null
        $null = $state.Pending.TryRemove($id, [ref]$removed)
        $where = "$($Connection.Transport) $($Connection.TransportTarget)"
        throw ("'{0}' failed on {1}: the server closed the connection before responding. " +
            "Check that an ACP agent is listening there and still running " +
            "(for the bundled agent: node dist/cli.js --tcp <port>, or spawn it with -Command).") -f $Method, $where
    }
    if ($tcs.Task.IsCanceled -or $tcs.Task.IsFaulted) {
        throw "The agent exited before responding to '$Method'."
    }
    $parsed = $tcs.Task.Result | ConvertFrom-Json
    if ($parsed.error) {
        throw "$Method failed: $($parsed.error.message)"
    }
    return $parsed
}

function Receive-AcpUpdateLine {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        $Connection,
        [System.Collections.Generic.List[object]]$Updates = [System.Collections.Generic.List[object]]::new(),
        [System.Text.StringBuilder]$Text = [System.Text.StringBuilder]::new(),
        [switch]$Quiet
    )
    $line = $null
    if (-not $Connection.State.Queue.TryDequeue([ref]$line)) {
        return $false
    }
    $notification = $line | ConvertFrom-Json
    $update = $notification.params.update
    $null = $Updates.Add($update)
    if ($update.sessionUpdate -eq 'current_mode_update') {
        $tracked = $Connection.State.Sessions[$notification.params.sessionId]
        if ($tracked) { $tracked.ModeId = $update.currentModeId }
    }
    switch ($update.sessionUpdate) {
        'agent_message_chunk' {
            $message = $update.content.text
            $null = $Text.Append($message)
            if (-not $Quiet) { Write-Host $message -NoNewline }
        }
        'agent_thought_chunk' {
            if (-not $Quiet) { Write-Host $update.content.text -NoNewline -ForegroundColor DarkGray }
        }
        'tool_call' {
            if (-not $Quiet) { Write-Host "`n[tool pending] $($update.title)" -ForegroundColor Yellow }
        }
        'tool_call_update' {
            if (-not $Quiet) { Write-Host "`n[tool $($update.status)] $($update.title)" -ForegroundColor Yellow }
        }
        'current_mode_update' {
            if (-not $Quiet) { Write-Host "`n[mode] $($update.currentModeId)" -ForegroundColor Cyan }
        }
        default {
            if (-not $Quiet) { Write-Host "`n[$($update.sessionUpdate)]" -ForegroundColor DarkGray }
        }
    }
    return $true
}

function Start-AcpReaderLoop {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        $Reader,
        [Parameter(Mandatory)]
        $Writer,
        [Parameter(Mandatory)]
        $State
    )

    # The reader runs in its own runspace: ReadLine blocks for the life of the
    # process, and the loop is pure .NET so it needs no cmdlets.
    $script = {
        param($reader, $writer, $state)
        try {
            while ($true) {
                $line = $reader.ReadLine()
                if ($null -eq $line) { break }
                if ([string]::IsNullOrWhiteSpace($line)) { continue }

                $method = $null
                $requestId = [long]0
                $hasRequestId = $false
                try {
                    $document = [System.Text.Json.JsonDocument]::Parse($line)
                    $root = $document.RootElement
                    try { $method = $root.GetProperty('method').GetString() } catch { $method = $null }
                    if ($method) {
                        try {
                            $requestId = $root.GetProperty('id').GetInt64()
                            $hasRequestId = $true
                        } catch { $hasRequestId = $false }
                    }
                } catch {
                    $hasRequestId = $false
                }

                if ($hasRequestId -and $method -eq 'session/request_permission') {
                    $optionId = if ($state['PermissionPolicy'] -eq 'Allow') { 'allow' } else { 'reject' }
                    $reply = '{"jsonrpc":"2.0","id":' + $requestId +
                        ',"result":{"outcome":{"outcome":"selected","optionId":"' + $optionId + '"}}}'
                    [System.Threading.Monitor]::Enter($state['SendLock'])
                    try { $writer.WriteLine($reply) } finally {
                        [System.Threading.Monitor]::Exit($state['SendLock'])
                    }
                    continue
                }

                if ($hasRequestId -and $method) {
                    # Unknown client-directed request: reject politely.
                    $reply = '{"jsonrpc":"2.0","id":' + $requestId +
                        ',"error":{"code":-32601,"message":"Method not found"}}'
                    [System.Threading.Monitor]::Enter($state['SendLock'])
                    try { $writer.WriteLine($reply) } finally {
                        [System.Threading.Monitor]::Exit($state['SendLock'])
                    }
                    continue
                }

                if ($method) {
                    $state['Queue'].Enqueue($line)
                    continue
                }

                $responseId = 0
                try { $responseId = [int]$root.GetProperty('id').GetInt64() } catch { continue }
                $tcs = $null
                if ($state['Pending'].TryRemove([int]$responseId, [ref]$tcs)) {
                    $null = $tcs.TrySetResult($line)
                }
            }
        } catch {
            # Reader failure is handled by the shutdown path below.
        } finally {
            $state['Running'] = $false
            foreach ($entry in $state['Pending'].ToArray()) {
                $null = $entry.Value.TrySetCanceled()
            }
            $state['Pending'].Clear()
        }
    }

    $readerHost = [powershell]::Create()
    $null = $readerHost.AddScript($script).AddArgument($Reader).AddArgument($Writer).AddArgument($State)
    $null = $readerHost.BeginInvoke()

    return $readerHost
}
