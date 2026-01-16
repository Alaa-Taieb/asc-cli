# Decision Journal

| Date | Decision | Rationale | Impact |
| :--- | :--- | :--- | :--- |
| 2026-01-16 | Use Python with Typer for CLI | Most developers have Python installed; `pip` handles PATH well; Typer provides modern CLI UX with minimal boilerplate | Limits audience to Python users, but simplifies distribution |
| 2026-01-16 | Bundle templates as fallback, prioritize cached | Enables offline-first usage while allowing updates from remote | Slightly larger package size; need to maintain template versioning |
| 2026-01-16 | Store synced templates in `~/.acs/templates/` | Centralized cache location allows sharing across projects | User needs write access to home directory |
| 2026-01-16 | Stick with `acs` command name | Investigated naming conflict; confirmed it was a local stale issue and no external package conflict exists. | Maintains desired project branding and UX |
| 2026-01-16 | Provide cross-platform installers | Solves the common "not on PATH" issue for Python CLI tools on Windows and Unix. | Faster and more reliable user onboarding |
| | | | |
