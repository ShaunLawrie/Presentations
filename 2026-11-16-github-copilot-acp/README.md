# GitHub Copilot and ACP

A roughly 20-30-minute, demo-led draft for developers familiar with Copilot about the ACP functionality and potential use-cases.

## Present

With Node.js 22.13+ and npm installed, run these commands in this directory to start the slidev presentation:

```sh
npm ci
npm run dev
```

## Present from GitHub Codespaces

Create a Codespace for this repository and select the **GitHub Copilot ACP
presentation** configuration. It installs Node.js 22, PowerShell, Copilot CLI,
and the slide dependencies, then starts Slidev automatically on port **3030**.
Open that port from the **Ports** tab to present the slides in your browser.
The forwarded port stays private to your GitHub account.

If you need to restart the slides, run this in the presentation terminal:

```sh
npm run dev:cloud
```

Startup output is saved to `/tmp/github-copilot-acp-slidev.log`.
For the Copilot CLI and PowerShell demos, run `copilot login` in the Codespace
and authenticate with an account that has Copilot access. Open a PowerShell
terminal with `pwsh` for the PowerShell client demo.

The Docker Sandbox demo requires its separate sandbox environment; this
Codespace provides the slides and the CLI/PowerShell demos.
Stop the Codespace when finished to avoid using additional compute time.
