# One ACP conversation

| Direction | Message | Purpose |
|---|---|---|
| Client → agent | `initialize` | Agree version and capabilities |
| Client → agent | `session/new` | Create a conversation |
| Client → agent | `session/prompt` | Start a turn |
| Agent → client | `session/update` | Stream text and tool activity |
| Agent ↔ client | `session/request_permission` | Ask for a tool decision |
| Agent → client | Prompt response | Return the stop reason |
