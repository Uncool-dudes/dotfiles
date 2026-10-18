---
description: Use when the user asks to create, switch to, list, or remove a git worktree, "/worktree", or wants to work on a branch in parallel without stashing. Uses this user's `wt` command and sibling <repo>.worktrees/<name> layout, not Claude Code's default .claude/worktrees/.
argument-hint: "<name> [base-branch] | list | rm <name>"
arguments: [arg1, arg2, arg3]
allowed-tools: Bash(wt:*) Bash(g:*) Bash(git:*)
---

# Worktree

This user has a `wt` command (home-manager-installed, `modules/core/scripts/wt.zsh`) that handles this - don't hand-construct `git worktree add` paths or re-derive branch resolution in prose, `wt` already encodes it.

Convention: worktrees live in a **sibling** directory `<repo>.worktrees/<name>` (e.g. `gamma.worktrees/ananth`), never inside the repo and never under `.claude/worktrees/`. Branch names are flat (`ananth`, `course`), no `feature/` prefix.

`$arg1` is always the first word typed after `/worktree`. It's a dispatch keyword for `list`/`rm`, but doubles as the worktree *name* for create (there's no literal "add" keyword) - check its value before deciding what `$arg2`/`$arg3` mean.

## Actions

- **Create**: `$arg1` is anything other than `list`/`rm` (it's the worktree name) - run `wt add "$arg1" "$arg2"`, where `$arg2` is the base branch, omitted to default to `main`. `wt` resolves the branch itself: local → remote-tracking → new-from-base, and prints `WORKTREE_PATH: <path>` on success.
  After it succeeds, this Claude Code session doesn't auto-follow: use `EnterWorktree` with the printed path explicitly if the user wants the session switched into it - Claude Code's own worktree tool hardcodes `.claude/worktrees/` inside the repo, which isn't this layout. On `ExitWorktree`, use `action: "keep"` - Claude didn't create this worktree through its own `name`-based tracking, so the default exit behavior shouldn't be trusted to leave it alone.

- **List**: `$arg1` is `list` - `wt list` (= `git worktree list`).

- **Remove**: `$arg1` is `rm` - `$arg2` is the worktree name - run `wt rm "$arg2"`. Uncommitted changes in that worktree: the plain remove refuses - ask the user before passing `--force` as `$arg3`, never force by default.

## Never

- `rm -rf` a worktree directory - always `wt rm`, so `git worktree` metadata stays in sync.
- Construct the sibling path by hand in a one-off `git worktree add ../...` - use `wt`, it resolves repo name/parent dir and branch state correctly regardless of cwd depth.
