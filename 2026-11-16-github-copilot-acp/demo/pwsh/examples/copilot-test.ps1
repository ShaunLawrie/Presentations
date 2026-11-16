$ErrorActionPreference = 'Stop'
Import-Module (Join-Path $PSScriptRoot '../FmACP.psd1') -Force

$conn = Connect-AcpAgent -Port 9977
try {
    Get-AcpAgent $conn | Format-List Transport, TransportTarget, ProtocolVersion, SessionCapabilities | Out-Host

    $sandbox = Join-Path ([System.IO.Path]::GetTempPath()) ("fm-acp-copilot-" + [guid]::NewGuid().ToString('N').Substring(0, 8))
    New-Item -ItemType Directory -Force $sandbox | Out-Null
    $session = New-AcpSession $conn -Cwd $sandbox
    Write-Host "`n=== copilot session $($session.SessionId) (mode $($session.Modes.currentModeId)) ===" -ForegroundColor Cyan

    $turn = Invoke-AcpPrompt $conn -SessionId $session.SessionId `
        -Prompt "Reply with exactly: copilot acp works"
    Write-Host "`n--- turn: stopReason=$($turn.StopReason) ---" -ForegroundColor Cyan

    Get-AcpSession $conn | Format-Table SessionId, Cwd, ModeId -AutoSize | Out-Host
    Write-Host "`n=== copilot test complete ===" -ForegroundColor Green
} finally {
    Disconnect-AcpAgent $conn
}
