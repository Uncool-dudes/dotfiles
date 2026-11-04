---
description: Use only when the user types "/yeet". Commits, pushes, and opens a draft PR for the current branch in one run, with a single confirmation before anything leaves the machine.
argument-hint: "optional flags passed through: no-verify, wip, split (to /commit), ready, base=<branch> (to /pr)"
arguments: [flag]
allowed-tools: Bash(gh:*) Bash(g:*) Bash(git:*)
disable-model-invocation: true
---

# Yeet

Thin orchestrator over `/commit` and `/pr`. Their rules (staging, message format, signing, draft PRs, force-push gate, stacked bases) live in those commands and in `commits.md`. Follow them there; do not restate or override them here.

Shell alias `g` = `git`. `$flag` is passed to whichever command understands it: `no-verify`, `wip`, `split` go to `/commit`; `ready`, `base=<branch>` go to `/pr`.

## Workflow

1. **Refuse on the default branch.** Compare `g branch --show-current` with the default branch from `g symbolic-ref --short refs/remotes/origin/HEAD` (drop the `origin/` prefix). If they match, or HEAD is detached, stop and tell the user to create a branch first. Do not create one for them.
2. **Commit.** If `g s` shows uncommitted changes, run `/commit`. If the tree is clean and there are no unpushed commits, stop and say there is nothing to ship.
3. **Check for fixups.** List unpushed commits with `g log --oneline @{upstream}..HEAD` (or `main..HEAD` when no upstream is set). If any subject starts with `fixup!`, remind the user that autosquash is a separate step they run (`rebase -i --autosquash <base>`). Do not autosquash. Ask whether to continue shipping the branch as is.
4. **Confirm before the push.** Show the commits that will be pushed, the branch name, and the PR base. Ask in a full sentence and continue only on an explicit yes. Anything else ends the run with nothing pushed.
5. **Push and open the PR.** Run `/pr`. It owns the push (including its personal-branch gate for force-pushes), base detection, and the hand-written title and body. A yes at step 4 does not waive that force-push gate.
6. **Report** the PR URL. Do not mark it ready, add reviewers, or merge.

## Never

- Skip the step 4 confirmation, even when invoked with flags.
- Autosquash or rewrite history on the user's behalf.
- Push by any path other than `/pr`.
- Add co-authorship lines or em dashes to any commit message or PR text. Attribution lines the session requires still apply.
