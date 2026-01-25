### Refined Version

*   Backend (Nest.js) lint issues are never fixed automatically — add a hook for this. Refer to `data-collection-migration/settings.json` and `hook/.sh` file.
*   Add a similar hook for the frontend (Next.js). Pending: `npx tsc --noEmit`.
*   Next.js requires `params` to be awaited.
*   Update the framework to support multiple tracks (e.g., two backends in parallel, frontend and backend fully independent). It should adapt to these scenarios.
*   Separate migration logs by worktree. Combining all attempts in one file breaks agent context.
*   Avoid continuous reading of agent outputs — it kills context when agents run in parallel (e.g., “Task Output(non-blocking)… still running”). Sequential feature implementation avoids this issue.
*   Sub-agents (frontend, QA, backend) should not send full responses to the main agent. Instead:
    *   Write output to a temp file.
    *   Return the file path + a brief 2-line summary.
    *   Delete temp files after completion.
    *   This prevents context flooding when multiple agents run in parallel.
*   Commit only files related to the current task. Do not auto-commit unrelated edits (e.g., `index.html` while migration runs).
*   Never switch branches unless explicitly requested. If on `/dev`, agents should merge changes into the current branch, not `master`. If limited, use `dev`.
*   Avoid polluting `master`. Always respect the active branch.
*   Run `npm i` after adding dependencies in the respective folder (backend or frontend).
*   When copying legacy CSS, isolate styles to the specific page using a parent wrapper class named accordingly.
*   Ensure proper DB setup with Docker for backend. Use project-specific volume names to avoid conflicts.
*   Integration QA should validate:
    *   Frontend UI matches expectations.
    *   API contracts and endpoints are correct.
    *   Backend implementation aligns with the contract.
*   Create a `README.md` for module/feature structure.
*   Before starting a feature, check for human escalations and notify the user.
*   Prefer manual foundation setup for projects:
    *   Robust Vite setup with state management, API handling, error boundaries, and component library.
    *   Backend with a working DB connection template.
*   API contracts should be feature-specific, not module-specific.
*   In `/migrate-diff`, use MCP servers (e.g., Chrome DevTools, Cypress) to test legacy and modern UI.
*   Ensure migration framework setup includes all user-level claude configurations within the project, specially currently in use statusline plugin.

