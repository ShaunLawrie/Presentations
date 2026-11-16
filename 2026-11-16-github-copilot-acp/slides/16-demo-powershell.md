---
class: powershell-demo
---

# A Simple PowerShell client

The ACP spec is well defined enough that it's easy to implement a minimal client yourself, allowing you to learn how ACP-driven agents operate, experiment with session management and prompt handling, and understand the flow of permission requests.

```powershell
# Start copilot in ACP TCP mode
copilot --acp --port 9977

# Load the FmACP PowerShell module
Import-Module "./demo/pwsh/FmACP.psd1" -Force

# Connect to the ACP agent
$connection = Connect-AcpAgent -PermissionPolicy Prompt -Port 9977

# Start a new session with the ACP agent
$session = New-AcpSession -Connection $connection

# Send a prompt to the ACP agent
Invoke-AcpPrompt -Connection $connection -SessionId $session.SessionId -Prompt "Can you create a dummy.txt file for me"
```
