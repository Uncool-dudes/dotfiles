---
description: Use when a merge, rebase, cherry-pick, revert, am, or stash pop leaves conflicted files, or the user asks to resolve a conflict / "/resolve". Walks through this user's zdiff3 + rerere setup instead of guessing at raw diff3 markers.
allowed-tools: Bash(g:*) Bash(git:*) Bash(git branchless:*)
---

# Conflict resolution

Before touching any conflicted file: state what each side changed and what would be lost by picking one over the other - this is a standing global rule (see CLAUDE.md "Merge conflicts"), not optional here. Never resolve by blindly taking "ours"/"theirs" wholesale without reading the diff first.

## Before starting a rebase/merge that might conflict

`g merge-tree --write-tree <branch1> <branch2>` does a real merge with no working tree or index changes - it just reports whether conflicts would occur and which files, without touching anything. Preview with this before an actual rebase/merge/`git branchless sync` when the user wants to know ahead of time whether it'll conflict, instead of just starting the real operation.

## Setup this user has

- `merge.conflictStyle = zdiff3` - conflict markers show three sections, not two: `<<<<<<<` ours, `|||||||` the common ancestor, `=======`, `>>>>>>>` theirs. The ancestor section tells you what each side actually changed *from*, not just the end states - use it to understand intent, not just content.
- `rerere.enabled` + `rerere.autoupdate` - if this exact conflict (same pre-image) was resolved before, git has already replayed and staged that resolution. Check `g staged`/`g d` before assuming a conflicted file needs manual work - it may already be done.
- `rebase.reschedulefailedexec = true` / `rebase.missingcommitscheck = warn` - during an interactive rebase (e.g. from `g sqa`-style cleanup or `git branchless`), a failed `exec` line gets auto-rescheduled rather than aborting the rebase; don't treat that as a new problem.

## Workflow

1. **Identify what's in progress** - `g s` only shows conflicted files, not the operation. Run `g status --porcelain=v2 --branch` for conflicted paths in a stable, parseable form (`u` lines); it still won't name the operation, so check markers under `g rev-parse --git-dir` (`$g`) in this order, matching git's own `git-prompt.sh` logic:
   - `$g/rebase-merge/` exists → rebase (interactive).
   - `$g/rebase-apply/` exists → `$g/rebase-apply/rebasing` present → rebase (non-interactive); `$g/rebase-apply/applying` present → `git am`, not a rebase at all; neither present → ambiguous `AM/REBASE` state.
   - `$g/MERGE_HEAD` → merge.
   - `$g/CHERRY_PICK_HEAD` → cherry-pick. `$g/REVERT_HEAD` → revert.
   - Neither HEAD file but `$g/sequencer/todo` exists and its next line starts `pick`/`p ` or `revert` → mid-sequence cherry-pick/revert (the HEAD file gets consumed once a manual commit resolves one step).
   - `$g/BISECT_LOG` → bisect.
   - None of the above, but `g ls-files --unmerged` is non-empty (git's own canonical "conflict exists" check) → stash pop, by elimination; confirm with `g stash list` if unsure.
   This user's conflicts are most often from `g pl` (rebase) or `g stash pop`, not merge - don't default to assuming a merge.
2. **Read before resolving** - for each conflicted file, read all three zdiff3 sections, and run `g log --merge --left-right --oneline -p -- <file>` (`--left-right` marks which side, `<`/`>`, each commit came from) to see the actual commits on both sides that touched it since the merge base. State in your response what each side changed and why, before editing.
3. **Resolve**:
   - Simple: edit the file directly, remove markers.
   - Complex/binary-ish diffs: `g mergetool` (opens `nvimdiff`, configured already - no setup needed).
   - Whole-file choice (`g checkout --ours -- <file>` / `--theirs`, then `g add <file>`): only when the user explicitly says which side to take, or step 2's read makes one side trivially correct (e.g. the other side is a no-op, a generated/lockfile-style file, or clearly superseded) - never as a default shortcut to skip reading the diff.
   - Botched a manual edit on one file: `g checkout -m -- <file>` recreates the original conflicted state (markers and all) for that file, discarding your in-progress edit - restart from step 2 on it rather than trying to hand-patch a mess.
4. **Stage resolved files** - `g a` for the whole resolution, or `git add <file>` per file if resolving incrementally.
5. **Finish, matching what step 1 identified** - these are not interchangeable:
   - **Rebase** (most common for this user, including `g pl`): `g rc` (= `rebase --continue`). Multiple commits queued - may conflict again on the next one, repeat from step 1.
   - **Stash pop** (second most common): no `--continue` exists. After staging, that's it - the working tree now has the merged result. The stash entry is *not* auto-dropped on a conflicting pop ("Index was not unstashed... kept in case you need it again") - run `g stash drop` yourself once you've confirmed the resolution is right, or leave it if unsure.
   - **Merge**: plain `g c` (merge commit object already staged by git, no `-m` needed unless changing the message).
   - **Cherry-pick**: `g cherry-pick --continue`. **Revert**: `g revert --continue`.
   - **`git am`** (only if step 1 found `rebase-apply/applying`, not `rebasing`): `git am --continue` - a different command from rebase despite living in the same directory.
6. **Abandoned commits on other branches** - if the conflict came from a rebase on a stacked branch, run `g branchless restack` afterward (same reasoning as `/commit`).
7. **Bailing out** - only if the user asks:
   - Rebase: `g ra` (= `rebase --abort`).
   - Merge: `g merge --abort`.
   - Cherry-pick: `g cherry-pick --abort`. Revert: `g revert --abort`.
   - `git am`: `git am --abort`.
   - Stash pop: no abort command - discard the conflicted working-tree state with `g checkout -- <file>` (or `g nuke` for everything), the stash entry is untouched either way since it was never dropped.
   - Use step 1's marker check to know which of these applies - never guess.

## Never

- Resolve by wholesale "take ours"/"take theirs" (`g checkout --ours/--theirs`) without reading what's actually being discarded.
- Disable rerere or clear its cache to "start clean" - the recorded resolutions are intentional, not a problem to work around.
- Commit a conflict resolution with leftover `<<<<<<<`/`=======`/`>>>>>>>` markers still in the file - grep for them before staging if in doubt.
