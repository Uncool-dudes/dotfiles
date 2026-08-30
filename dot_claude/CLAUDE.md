# Claude Global Instructions

## Communication style

Caveman mode — full level. Drop articles, filler, pleasantries, hedging. Fragments OK. Technical terms exact. Code blocks normal.
No drift to full sentences across long session. Permanent until "stop caveman" or "normal mode".

## Commits

No co-authorship lines. Ever. Conventional Commits. Subject ≤50 chars. Body only when "why" non-obvious.
No em dashes (—) anywhere — in commit messages, code, comments, docs. Use `-` or `--`.

### Fixup commits (preferred over amend/new-unrelated-commit)

User likes fixup commits for follow-on fixes to work already on the branch. When fixing/extending a commit that's already landed on the current branch, try `git absorb` first - it blames each changed hunk to find its owning commit and auto-creates the right `fixup!` commit(s), splitting across multiple target commits if different hunks in the same file are owned by different commits. This is more precise than picking one target by hand, and it declines (leaves unstaged) rather than guessing wrong on ambiguous hunks like whole-file deletes/renames - handle those leftover hunks with manual `git commit --fixup=<target-sha>`. User runs `git rebase -i --autosquash <base>` themselves later to fold them in.

**Missteps to avoid:**
- **Create fixups immediately after the commit they target, not at the end of a multi-commit session.** If other real (non-fixup) commits land on the branch after the target but before the fixup is created, and those commits touch the same file the fixup touches, `--autosquash` will conflict: it replays the fixup right after its target, skipping the intervening real commits, so the diff context won't match. Symptom: modify/delete or context-mismatch conflicts on files the fixup didn't intend to fight over. If this happens, resolve favoring the fixup's intended end state — it's not a sign the fixup was wrong, just an ordering artifact.
- One logical change per fixup. Don't bundle e.g. "drop a subdirectory" and "fix imports" into one fixup commit — split them (one `git add`+commit per concern) so `rebase -i` history stays legible even before autosquash folds them away.
- Always rebuild/vet after creating a fixup, before telling the user it's ready - a fixup that doesn't compile against the rest of the stack is worse than no fixup.

## Code

- No comments unless WHY non-obvious. Never describe what code does.
- Never summarize after file edits. Diff speaks for itself.
- No abstractions beyond task scope.
- Edits to source files, not deployed/generated.
- `go build` wins over LSP diagnostics. Pre-existing warnings unrelated to change: note as pre-existing, don't block.
- New code: `errors.Is` over `==` for sentinel comparisons.
- User rejects script: two-line manual edit, not regeneration.

## Remote ops

- Remote reads: emit `ssh host cat file` for user. No direct access.
- Remote writes: stage locally, give user rsync command. Never `ssh host "python3 -c ..."`.
- Destructive git ops / large reverts: confirm scope first.
- Merge conflicts: state lost functionality before resolving.

## Database

- Never `pg_dump`. Use `psql` with `information_schema` or `pg_catalog`.

## Observability

- Never call Agent0 (Dash0 MCP `runTask`/Agent0 tools).

## Tools

Modern CLI over standard:

- `fd` over `find` — `fd <pattern>`, `fd -e ext`, `fd -t f/d`, `fd --hidden`
- `rg` over `grep` — `rg <pattern>`, `rg -t go`, `rg -l`, `rg --no-heading`
- `bat` over `cat` — `bat <file>`, `bat -n` (line numbers), `bat -p` (plain)
- `eza` over `ls` — `eza -la`, `eza --tree`, `eza --git`
- `dust` over `du` — `dust`, `dust -d 2`
- `duf` over `df` — `duf`
- `procs` over `ps` — `procs <name>`
- `sd` over `sed` — `sd 'old' 'new' file`
- `xh` over `curl`/`wget` — `xh GET url`, `xh POST url key=val`
- `jq` for JSON — pretty-print with `jq .`

Git compact:
- `git status -s`
- `git log --oneline -n 20`
- `git diff --stat`

Also:
- `hyperfine` over `time` — `hyperfine 'cmd'`, `hyperfine --warmup 3 'cmd'`
- `tokei` over `wc -l` — `tokei`, `tokei -t Go,Nix`
- `fx` interactive JSON — `cat file.json | fx`
- `mlr` over `awk`/`cut` — `mlr --csv cut -f col1,col2 file.csv`
- `watchexec` over `watch` — `watchexec -e go -- go test ./...`
- `glow` markdown — `glow README.md`
- `bandwhich` network by process — `sudo bandwhich`
- `hl` log files — `hl <file>`, `cmd | hl`
- `dive` docker images — `dive <image>`
- `grex` generate regex — `grex example1 example2`
- `witr` process inspector — `witr <name>` (substring), `witr -x <name>` (exact), `witr -p <pid>`, `witr -o <port>`, `witr -f <file>`, `witr -c <container>`; flags repeatable/mixable. `-s` ancestry, `-t` tree, `--env` env vars, `--verbose` extended, `--json` machine output. No args = TUI (`-i` force TUI). Searches Docker/Podman/K8s/LXC with `-c`.

@RTK.md
# graphify
- **graphify** (`~/.claude/skills/graphify/SKILL.md`) - any input to knowledge graph. Trigger: `/graphify`
When the user types `/graphify`, use the installed graphify skill or instructions before doing anything else.
