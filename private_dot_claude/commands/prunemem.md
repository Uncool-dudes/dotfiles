---
description: Use only when the user types "/prunemem". Finds low-value claude-mem observations, shows them for approval, then deletes only what the user confirms, after a DB backup.
argument-hint: "[project] [older-than-days, default 14]"
arguments: [project, days]
allowed-tools: Bash(sqlite3:*) Bash(xh:*) Bash(lsof:*) Bash(jq:*) Bash(mkdir:*)
---

# Prune claude-mem

Data lives in `~/.claude-mem/claude-mem.db` (SQLite). Observations are mirrored in FTS tables and a Chroma vector store, so never `DELETE` rows with sqlite3. Delete through the worker API, which keeps all three in sync.

Find candidates with claude-mem's MCP tools (`mem_search`, `timeline`, `get_observations`; load via `ToolSearch`). They are the supported read path and need no DB lock. Use sqlite3 only for the duplicate query (search cannot express a group-by) and the backup.

## Rules

- Read with `sqlite3 -readonly -cmd ".timeout 5000"`. The worker holds the DB open and an unbounded query can hang; keep queries indexed (filter on `project` or `created_at_epoch` first) and add `LIMIT`.
- Nothing is deleted without an explicit user approval of the exact id list in this conversation.
- Scope to `$project` when given. With no project, report counts per project and ask which to prune; do not prune all projects in one run.
- `relevance_count` is 0 on nearly every row, so it is not a usable signal. Do not rank by it.
- Never touch `session_summaries`, `user_prompts`, or `work_state_entries`.

## Steps

1. Find the worker port: PID from `jq -r .processes.worker.pid ~/.claude-mem/supervisor.json`, then `lsof -nP -a -p <pid> -iTCP -sTCP:LISTEN`. Use `127.0.0.1:<port>`, not `localhost`.
2. Show per-project and per-type counts for the scope.
3. Collect candidates older than `$days` days (default 14), in this order of confidence:
   - **Duplicates**: same `project` and `title_norm_key` with more than one row. Keep the newest, list the rest.
   - **Routine discoveries**: `mem_search` (scoped to the project, `type` discovery) for read-only lookups such as file listings, tool doc fetches, and version checks. Verify each hit with `get_observations` and drop any that has a `decision`, `bugfix`, or `security_*` sibling in the same session.
   - Never propose `decision`, `security_alert`, or `security_note` rows.
4. Print a table: `id`, `type`, `created_at`, `title`, and the reason. Cap at 100 rows per run. Ask the user to approve all, a subset of ids, or none.
5. On approval, back up first: `mkdir -p ~/.claude-mem/backups` then `sqlite3 ~/.claude-mem/claude-mem.db ".backup ~/.claude-mem/backups/claude-mem-pre-prune-$(date +%Y%m%dT%H%M%S).db"`. Stop if the backup fails.
6. Delete each approved id: `xh --timeout=10 DELETE 127.0.0.1:<port>/api/observation/<id>`. Stop at the first non-2xx and report it.
7. Report how many were deleted and the backup path.
