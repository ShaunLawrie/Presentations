# FmACP — a minimal PowerShell ACP client

A small PowerShell module for testing ACP agents — primarily
[fm-acp-agent](../agent/README.md). It speaks JSON-RPC 2.0 over
newline-delimited framing on two mutually exclusive transports, auto-answers
`session/request_permission` according to the configured policy, and streams
`session/update` events live to the console while a prompt turn runs.

This is a test harness, not a production client: no persistence, no MCP, and
permission answers are Allow/Reject policy rather than interactive prompts.

## Setup

Build the agent bundle once, then import the module:

```sh
../agent/pnpm build
Import-Module ./FmACP.psd1 -Force
```

## Transports

`Connect-AcpAgent` takes exactly one of:

| Parameter set | Parameters | Behaviour |
| --- | --- | --- |
| `Stdio` (default) | `-Command`, `-ArgumentList`, `-Environment`, `-WorkingDirectory` | Spawns the agent and speaks ACP over its stdio. With no `-Command` it defaults to `node ../agent/dist/cli.js`. `-Environment` sets child-process environment variables (e.g. `FM_BRIDGE_URL`, `FM_BRIDGE_TOKEN` for the bundled agent). |
| `Tcp` | `-Port`, `-AgentHost` (default `127.0.0.1`) | Connects to an ACP server already listening on TCP. Verified against the bundled agent (`node dist/cli.js --tcp <port>`) and GitHub Copilot CLI (`copilot --acp --port <n>`). The framing is identical newline-delimited JSON-RPC. |

TCP frames are written UTF-8 **without a BOM** — a BOM corrupts the first
frame for strict line parsers and the server closes the connection during
`initialize`.

## Session walkthrough

```powershell
# 1. Connect (starts node ../agent/dist/cli.js and initializes).
$conn = Connect-AcpAgent -Environment @{ FM_BRIDGE_URL = 'http://127.0.0.1:1977' }

# 2. Open a session against a working directory.
$session = New-AcpSession $conn -Cwd ~/tmp/fm-sandbox
$session.SessionId

# 3. Send a prompt; updates stream live, tool calls show in yellow.
$turn = Invoke-AcpPrompt $conn -SessionId $session.SessionId `
    -Prompt "Use the shell tool to run 'echo hello from pwsh'."
$turn.StopReason     # end_turn
$turn.Text           # the assembled agent message

# 4. Modes.
Set-AcpMode $conn -SessionId $session.SessionId -ModeId 'auto-edit'

# 5. Cancel an in-flight turn (run from a second shell or a background job).
Send-AcpCancel $conn -SessionId $session.SessionId

# 6. Done.
Disconnect-AcpAgent $conn
```

## Testing permission denial

The reader answers permission requests from a policy string on the
connection, so you can flip it between prompts:

```powershell
$session = New-AcpSession $conn -Cwd ~/tmp/fm-sandbox
Invoke-AcpPrompt $conn -SessionId $session.SessionId `
    -Prompt "Use the write tool to create notes.txt containing 'hi'."

# Now deny:
$conn.State.PermissionPolicy = 'Reject'
Invoke-AcpPrompt $conn -SessionId $session.SessionId `
    -Prompt "Use the write tool to create other.txt containing 'hi'."
# -> [tool failed] ... and the model is told the permission was denied.

$conn.State.PermissionPolicy = 'Allow'
```

## Inspecting state (getters)

The agent advertises `sessionCapabilities: { list, delete }`, so the client
can query and clean up:

```powershell
Get-AcpAgent $conn                    # connection state + advertised capabilities
Get-AcpSession $conn                  # session/list: sessionId, cwd, updatedAt, tracked ModeId
Get-AcpSession $conn -Source Local    # locally tracked sessions only
Get-AcpMode $conn -SessionId $id      # current permission mode (client-tracked)
Get-AcpUpdate $conn -Show             # drain queued notifications (e.g. late mode changes)
Remove-AcpSession $conn -SessionId $id  # session/delete
```

`Get-AcpSession` merges the agent's `session/list` with the client-side
registry so the `ModeId` column reflects `current_mode_update` notifications;
`Get-AcpMode` drains queued notifications first, so a mode set in another way
is still current.

## Authentication

If the agent's initialize response advertises `authMethods` (e.g. Copilot's
`copilot-login`), the module automatically calls `authenticate` with the
first method before returning from `Connect-AcpAgent`. Failure surfaces as a
clear error and the transport is torn down. Third-party agents may advertise
different session capabilities (Copilot advertises `close`/`list`, not
`delete`), so `Remove-AcpSession` throws a capability error instead of
guessing. Unknown `session/update` variants (Copilot streams
`session_info_update`, `config_option_update`, `usage_update`, ...) print
generically and are collected like any other update.

## Notes

- Stdio default command is `node ../agent/dist/cli.js` (resolved relative to
  the module); override with `-Command` / `-ArgumentList` to test other
  agents. `-Environment` passes child environment variables — keep
  bridge-specific configuration there rather than in this module, which is
  transport-agnostic.
- TCP requires an agent serving `--tcp <port>`; the bundled agent supports it
  (all connections share one session store).
- `Invoke-AcpPrompt` polls the response task at 100 ms so streaming appears
  with at most that latency; `-TimeoutSeconds` bounds the whole turn.
- `session/update` notifications that arrive between prompts (e.g.
  `current_mode_update` from `Set-AcpMode`) are drained by the next cmdlet
  call and printed as `[mode] ...`.
