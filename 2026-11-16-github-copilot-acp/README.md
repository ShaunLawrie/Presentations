# GitHub Copilot and ACP

A roughly 20-30-minute, demo-led draft for developers familiar with Copilot about the ACP functionality in the copilot CLI and potential use-cases.

![Presenting at PwC Melbourne](B9D92D19-455F-4464-A5AC-B07753098DBF_1_201_a.jpeg)

## Present

Run these commands in this directory to start the slidev presentation:

```sh
npm ci
npm run dev
```

## Slides

1. GitHub Copilot

   ![GitHub Copilot](screenshots/01.png)

2. What is ACP?

   ![What is ACP?](screenshots/02.png)

   [ACP architecture](https://agentclientprotocol.com/get-started/architecture)

3. Copilot SDK vs ACP

   ![Copilot SDK vs ACP](screenshots/03.png)

4. Why ACP when we have the CLI?

   ![Why ACP when we have the CLI?](screenshots/04.png)

5. One ACP conversation

   ![One ACP conversation](screenshots/05.png)

6. CLI and ACP

   ![CLI and ACP](screenshots/06.png)

7. Where does the work execute?

   ![Where does the work execute?](screenshots/07.png)

8. Execution inside a sandbox

   ![Execution inside a sandbox](screenshots/08.png)

9. Control access in the client

   ![Control access in the client](screenshots/09.png)

10. Extend the harness with elicitation

    ![Extend the harness with elicitation](screenshots/10.png)

11. Copilot in Docker Sandboxes

    ![Copilot in Docker Sandboxes](screenshots/11.png)

12. Copilot in a Docker Sandbox

    ![Copilot in a Docker Sandbox](screenshots/12.png)

13. Check the sandbox boundary

    ![Check the sandbox boundary](screenshots/13.png)

14. Other ACP clients

    ![Other ACP clients](screenshots/14.png)

15. Integrate with pipelines

    ![Integrate with pipelines](screenshots/15.png)

16. A Simple PowerShell client

    ![A Simple PowerShell client](screenshots/16.png)

17. Choosing your integration

    ![Choosing your integration](screenshots/17.png)

18. Resources and questions

    ![Resources and questions](screenshots/18.png)

    - [Copilot ACP reference](https://docs.github.com/en/copilot/reference/copilot-cli-reference/acp-server)
    - [ACP protocol and client directory](https://agentclientprotocol.com/get-started/clients)
    - [Copilot SDK](https://github.com/github/copilot-sdk)
    - [Docker's Copilot sandbox guide](https://docs.docker.com/ai/sandboxes/agents/copilot/)
    - [Microsoft walkthrough](https://techcommunity.microsoft.com/blog/azuredevcommunityblog/from-terminal-to-autonomous-coding-mastering-github-copilot-cli-acp-server/4508604)
    - [GitHub ACP announcement and discussion](https://github.com/orgs/community/discussions/185860)
