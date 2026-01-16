# Decision Journal

| Date | Decision | Rationale | Impact |
| :--- | :--- | :--- | :--- |
| 2026-01-16 | Use Python with Typer for CLI | Most developers have Python installed; `pip` handles PATH well; Typer provides modern CLI UX with minimal boilerplate | Limits audience to Python users, but simplifies distribution |
| 2026-01-16 | Bundle templates as fallback, prioritize cached | Enables offline-first usage while allowing updates from remote | Slightly larger package size; need to maintain template versioning |
| 2026-01-16 | Store synced templates in `~/.acs/templates/` | Centralized cache location allows sharing across projects | User needs write access to home directory |
| | | | |
