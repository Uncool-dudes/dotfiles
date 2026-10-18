---
description: Use when the user asks to open/create a PR, "/pr", or work on the current branch is ready for review. Opens a GitHub PR as a draft with a hand-crafted Conventional-Commit-style title and body, using this user's git/gh aliases.
argument-hint: "optional flags: ready, base=<branch>"
arguments: [flag]
allowed-tools: Bash(gh:*) Bash(g:*) Bash(git:*)
---

# PR

Shell alias `g` = `git`. `gh` has aliases: `gh co` (= `pr checkout`), `gh prs` (= `pr list --author @me`), `gh ready` (= `pr ready`), `gh approve` (= `pr review --approve`), `gh reviewer` (= `pr edit --add-reviewer`).

## Workflow

1. **Clean working tree** - `g s`. Uncommitted changes: run `/commit` first, don't hand-roll a commit here.
2. **Push** - `g p` (upstream auto-sets via `push.autoSetupRemote`, no `-u`). Branch already pushed and history was rewritten (rebase/amend): that's a force-push - follow `/commit`'s personal-branch gate before `g pf`.
3. **Determine base**:
   - `$flag` is `base=<branch>`: use that branch, skip the check below.
   - Otherwise inspect `g tree` / `g log --oneline main..HEAD` - if the branch forked straight off `main`, base is `main`.
   - If it forked off another non-main branch (stacked), ask the user which base to target - don't assume `main`. If the stack needs rebasing onto latest `main` first, `git branchless sync` rebases every local stacked branch in one pass, no per-branch checkout - only run it if asked, not proactively.
4. **Compose title + body by hand** - never rely on `--fill`:
   - Title: Conventional Commit format per `commits.md` (imperative, ≤50 chars, no emoji, no co-authorship).
   - Body: summarize the change and why, not a commit-by-commit log. No template file exists in this repo - write a plain summary + test plan, skip template-matching logic entirely.
5. **Create as draft**:
   ```
   gh pr create --draft --title "<title>" --body "<body>" --base <base>
   ```
   - `$flag` is `ready`: create without `--draft` instead (`gh pr create --title ... --body ... --base <base>`).
6. **After creation** - report the PR URL. Don't mark ready, add reviewers, or merge unless asked; those are `gh ready`, `gh reviewer`, `gh pr merge` respectively.
7. **After the PR merges** - don't clean up proactively. If the user asks to clean up local branches, run `gh poi` (checks actual PR merge state via the API, catches squash/rebase-merges that plain `git branch --merged` misses).

## Never

- `gh pr create --fill` - title/body are always hand-crafted here, per this user's preference.
- Assume `main` as base without checking for a stacked parent branch first.
- `git push --force` (plain) - force-push only via `g pf`, gated by `/commit`'s personal-branch check.
