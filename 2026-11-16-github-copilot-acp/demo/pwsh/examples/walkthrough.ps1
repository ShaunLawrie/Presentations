# End-to-end walkthrough of the FmACP module against a running fm-bridge.
# Usage: pwsh examples/walkthrough.ps1 [-BridgeUrl http://127.0.0.1:1977] [-RejectTest]
param(
    [string]$BridgeUrl = 'http://127.0.0.1:1977',
    [switch]$RejectTest
)

$ErrorActionPreference = 'Stop'
Import-Module (Join-Path $PSScriptRoot '../FmACP.psd1') -Force

$conn = Connect-AcpAgent -Environment @{ FM_BRIDGE_URL = $BridgeUrl }

try {
    # --- 1. Session ----------------------------------------------------------
    $sandbox = Join-Path ([System.IO.Path]::GetTempPath()) ("fm-acp-pwsh-" + [guid]::NewGuid().ToString('N').Substring(0, 8))
    New-Item -ItemType Directory -Force $sandbox | Out-Null
    $session = New-AcpSession $conn -Cwd $sandbox
    Write-Host "`n=== session $($session.SessionId) (mode $($session.Modes.currentModeId)) ===" -ForegroundColor Cyan

    # --- 2. A tool round-trip ------------------------------------------------
    $turn = Invoke-AcpPrompt $conn -SessionId $session.SessionId `
        -Prompt "Use the shell tool to run 'echo pwsh acp works' and then report the output."
    Write-Host "`n--- turn 1: stopReason=$($turn.StopReason) ---" -ForegroundColor Cyan

    # --- 3. auto-edit mode: a write tool call without permission prompts -----
    $null = Set-AcpMode $conn -SessionId $session.SessionId -ModeId 'auto-edit'
    $turn = Invoke-AcpPrompt $conn -SessionId $session.SessionId `
        -Prompt "Use the write tool to create hello.txt containing exactly 'written by pwsh', then read it back with the read tool to confirm."
    Write-Host "`n--- turn 2: stopReason=$($turn.StopReason) ---" -ForegroundColor Cyan
    $written = Get-Content (Join-Path $sandbox 'hello.txt') -ErrorAction SilentlyContinue
    Write-Host "sandbox hello.txt: '$written'" -ForegroundColor Cyan

    # --- 4. Permission denial ------------------------------------------------
    if ($RejectTest) {
        $conn.State.PermissionPolicy = 'Reject'
        $turn = Invoke-AcpPrompt $conn -SessionId $session.SessionId `
            -Prompt "Use the shell tool to run 'touch denied.txt'."
        Write-Host "`n--- turn 3 (denied): stopReason=$($turn.StopReason) ---" -ForegroundColor Cyan
        $conn.State.PermissionPolicy = 'Allow'
    }

    # --- 5. Getters ----------------------------------------------------------
    Write-Host "`n=== agent status ===" -ForegroundColor Cyan
    Get-AcpAgent $conn | Format-List | Out-Host

    Write-Host "=== sessions (via session/list) ===" -ForegroundColor Cyan
    Get-AcpSession $conn | Format-Table SessionId, Cwd, ModeId, UpdatedAt -AutoSize | Out-Host

    Write-Host "=== mode of the active session ===" -ForegroundColor Cyan
    Get-AcpMode $conn -SessionId $session.SessionId | Format-Table -AutoSize | Out-Host

    Write-Host "=== deleting the session, then listing again ===" -ForegroundColor Cyan
    Remove-AcpSession $conn -SessionId $session.SessionId
    Get-AcpSession $conn | Format-Table SessionId -AutoSize | Out-Host

    Write-Host "`n=== walkthrough complete ===" -ForegroundColor Green
} finally {
    Disconnect-AcpAgent $conn
}
