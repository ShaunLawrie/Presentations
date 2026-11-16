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
presentation** configuration. It uses Ubuntu 24.04 and installs Node.js 22,
PowerShell, Copilot CLI, Docker Engine, Docker Sandboxes (`sbx`), and the slide
dependencies, then starts Slidev automatically on port **3030**.
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

### Docker Sandboxes

The image installs `docker-sbx` from Docker's official Ubuntu apt repository,
following the [Ubuntu installation instructions](https://docs.docker.com/ai/sandboxes/install/#install-on-ubuntu).
Sign in and check the installation:

```sh
sbx --version
sbx login
docker info
ls -l /dev/kvm
kvm-ok
```

Local sandboxes require usable `/dev/kvm` access and nested virtualization on
the host. An Ubuntu container and Docker Engine alone do not provide KVM.
The startup script grants the container's `kvm` group access to the exposed
KVM device on each start; the `vscode` user belongs to that group.
If the Codespace host does not expose KVM, run the local sandbox demo on a
KVM-capable Ubuntu machine, or use
[Docker cloud sandboxes](https://docs.docker.com/ai/sandboxes/cloud/)
with `sbx --cloud` (requires a Docker Agentic Platform subscription).
Cloud sandboxes have different workspace and authentication requirements;
the local sandbox demo commands are not interchangeable with cloud commands.

Stop the Codespace when finished to avoid using additional compute time.
