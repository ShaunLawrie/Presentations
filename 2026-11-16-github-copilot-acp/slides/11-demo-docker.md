# Copilot in a Docker Sandbox

```sh
sbx create --name copilot-acp-demo copilot "$PWD/demo/fixture"
```

Then connect an ACP client, like `agent-canvas` to the sandbox:

```sh
sbx exec -i copilot-acp-demo copilot --acp --stdio
```

**Watch for:** workspace and network isolation

<p class="aside"><code>-i</code> keeps stdin open so the ACP client can communicate interactively with the sandboxed agent</p>
