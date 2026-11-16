---
class: architecture
---

# Copilot SDK vs ACP

<div class="architecture-paths">
<div>

## Copilot SDK

```mermaid
flowchart TB
  S["Your application<br/>Copilot SDK"]
  S <-->|SDK JSON-RPC| C["Copilot CLI<br/>server mode"]
```

SDK manages the child process over a proprietary JSON-RPC protocol.

</div>
<div>

## ACP · stdio

```mermaid
flowchart TB
  A[Any ACP client]
  A <-->|ACP over stdin / stdout| C["Copilot CLI<br/>--acp --stdio"]
```

Client manages the child process over the standard ACP protocol.

</div>
<div>

## ACP · TCP

```mermaid
flowchart TB
  A["Any ACP client<br/>IDE · script · tool"]
  A <-->|ACP over TCP socket| C["Copilot CLI<br/>--acp --port 3000"]
```

Server runs independently. Compatible clients connect with ACP over TCP.

</div>
</div>
