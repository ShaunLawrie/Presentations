# Control access in the client

- Advertise only the extension capabilities you implement e.g. elicitation, file read/write
- Scope file operations to approved directory roots
- Run terminal callbacks in the intended execution environment
- Ask for permission with enough context to make a decision
- Extend the harness with client capabilities

<p class="aside">Agents have their own tools and the client can expose more features to the agent to extend its capabilities.</p>
