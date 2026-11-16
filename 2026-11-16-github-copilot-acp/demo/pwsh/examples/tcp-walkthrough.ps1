# TCP walkthrough: the agent serves ACP over TCP with '--tcp <port>', and the
# module connects with -Port instead of spawning a process.
# Usage: pwsh examples/tcp-walkthrough.ps1 [-Port 1984] [-BridgeUrl http://127.0.0.1:1977]
param(
    [int]$Port = 1984,
    [string]$BridgeUrl = 'http://127.0.0.1:1977'
)

$ErrorActionPreference = 'Stop'
Import-Module (Join-Path $PSScriptRoot '../FmACP.psd1') -Force

$bundle = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot '../../agent/dist/cli.js'))
if (-not (Test-Path $bundle)) {
    throw "Agent bundle not found at '$bundle'. Build it with 'pnpm build' in fm-agent-harness/agent."
}

# Start the agent with a TCP listener (shared session store across connections).
$agent = Start-Process -FilePath 'node' `
    -ArgumentList @($bundle, '--tcp', "$Port") `
    -RedirectStandardError (Join-Path ([System.IO.Path]::GetTempPath()) 'fm-acp-tcp-stderr.log') `
    -RedirectStandardOutput (Join-Path ([System.IO.Path]::GetTempPath()) 'fm-acp-tcp-stdout.log') `
    -PassThru

try {
    # Wait for the listener.
    $ready = $false
    for ($attempt = 0; $attempt -lt 50 -and -not $ready; $attempt += 1) {
        $probe = New-Object System.Net.Sockets.TcpClient
        try {
            $probe.Connect('127.0.0.1', $Port)
            $ready = $probe.Connected
        } catch { }
        finally { $probe.Close() }
        if (-not $ready) { Start-Sleep -Milliseconds 200 }
    }
    if (-not $ready) { throw "The agent did not open TCP port $Port." }
    Write-Host "Agent listening on tcp 127.0.0.1:$Port (pid $($agent.Id))" -ForegroundColor DarkGray

    # ACP over TCP: no -Command, just -Port.
    $conn = Connect-AcpAgent -Port $Port

    $session = New-AcpSession $conn -Cwd (Get-Location).Path
    Write-Host "`n=== session $($session.SessionId) (mode $($session.Modes.currentModeId)) ===" -ForegroundColor Cyan

    $turn = Invoke-AcpPrompt $conn -SessionId $session.SessionId `
        -Prompt "Use the shell tool to run 'echo acp over tcp works' and then report the output."
    Write-Host "`n--- turn: stopReason=$($turn.StopReason) ---" -ForegroundColor Cyan

    Get-AcpAgent $conn | Format-List Transport, TransportTarget, TrackedSessions, SessionCapabilities | Out-Host
    Get-AcpSession $conn | Format-Table SessionId, Cwd, ModeId -AutoSize | Out-Host

    Disconnect-AcpAgent $conn
    Write-Host "`n=== tcp walkthrough complete ===" -ForegroundColor Green
} finally {
    if (-not $agent.HasExited) { $agent.Kill() }
}
