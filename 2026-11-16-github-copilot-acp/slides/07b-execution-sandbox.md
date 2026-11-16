---
class: execution-diagram
---

# Execution inside a sandbox

```mermaid
flowchart LR
  subgraph H[Host machine]
    direction LR
    C["Client<br/>editor / script"]
    subgraph S[Sandbox boundary]
      direction LR
      A["Copilot CLI<br/>ACP server"] --> F["Shared workspace<br/>sandbox shell"]
    end
    C <-->|ACP stdio / TCP| A
  end
```

The client stays on the host. **The agent's tools run in the sandbox.**

<p class="aside">Share only the workspace the agent needs.<br>Host-side client callbacks and MCP tools need their own controls.</p>
