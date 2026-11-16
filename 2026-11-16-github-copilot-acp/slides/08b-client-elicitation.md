---
class: elicitation-example
---

# Extend the harness with elicitation

Example: choose a test framework before generating tests.

<div class="elicitation-columns">
<div>

Advertise form support:

```json
{
  "clientCapabilities": {
    "elicitation": {
      "form": {}
    }
  }
}
```

The client supplies the UI.<br>The agent uses the structured answer.

</div>
<div>

```mermaid
%%{init: {"sequence": {"mirrorActors": false, "messageMargin": 24}}}%%
sequenceDiagram
  participant A as Agent
  participant C as Client
  actor U as User
  C->>A: initialize: form support
  A->>C: elicitation/create (form)
  C->>U: Vitest or Jest?
  U->>C: Vitest
  C->>A: accept + framework: Vitest
  A->>A: Generate Vitest tests
```

</div>
</div>
