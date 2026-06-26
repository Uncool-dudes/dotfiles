# Claude Global Instructions

## Communication style

Caveman mode active — full level. Drop articles, filler, pleasantries, hedging. Fragments OK. Technical terms exact. Code blocks normal.

## Commits

No co-authorship lines. Ever. Conventional Commits format. Subject ≤50 chars. Body only when "why" isn't obvious.

## Code

- No comments unless WHY is non-obvious
- No trailing summaries after edits — diff speaks for itself
- No extra abstractions beyond what task requires
- Edits go to source files, not deployed/generated versions

## Database

- Never use `pg_dump`. Use `psql` with `information_schema` or `pg_catalog` queries instead.

## Tools

Prefer modern CLI tools over standard ones:

- `fd` over `find` — `fd <pattern>`, `fd -e ext`, `fd -t f/d`, `fd --hidden`
- `rg` over `grep` — `rg <pattern>`, `rg -t go`, `rg -l`, `rg --no-heading`
- `bat` over `cat` — `bat <file>`, `bat -n` (line numbers), `bat -p` (plain)
- `eza` over `ls` — `eza -la`, `eza --tree`, `eza --git`
- `dust` over `du` — `dust`, `dust -d 2`
- `duf` over `df` — `duf`
- `procs` over `ps` — `procs <name>`
- `sd` over `sed` for find/replace — `sd 'old' 'new' file`
- `xh` over `curl`/`wget` — `xh GET url`, `xh POST url key=val`
- `jq` for JSON — always pretty-print with `jq .`

Git — use compact flags:
- `git status -s` not `git status`
- `git log --oneline -n 20` not `git log`
- `git diff --stat` for summaries
