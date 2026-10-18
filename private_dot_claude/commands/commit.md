---
description: Use when the user asks to commit, "/commit", or work is ready to be checkpointed. Builds a Conventional Commit using this user's git aliases and config instead of raw git commands.
argument-hint: "optional flags: no-verify, wip, amend, split"
arguments: [flag]
allowed-tools: Bash(g:*) Bash(git:*)
---

# Commit

Rules for message format, scope, body, and fixup workflow live in `commits.md` (already in global instructions) - follow those. This command only covers *which commands* to run, tuned to this user's `~/.gitconfig`.

## Workflow

Shell alias `g` = `git`. Use `g` for every command below, not `git`.

## Arguments

`$flag` holds the arg passed to `/commit` (e.g. `/commit no-verify`), empty if none given.

| `$flag` value | Effect |
|---|---|
| `no-verify` | Satisfies the "explicit ask" requirement in step 4 - append `--no-verify` to the commit command instead of asking separately. |
| `wip` | Skip the WIP-is-it-done check in step 1 - commit as WIP outright (subject prefixed `wip:` or similar), don't ask. |
| `amend` | Skip the "new commit vs continue WIP" branching in step 1 - go straight to step 6 (`g amend`/`g reword`) on HEAD regardless of its subject. |
| `split` | Force the multi-concern split in step 2 even if the diff could pass as one commit - useful when the user wants finer-grained history on purpose. |

1. **Inspect state** - `g s` (= `status -sb`), then `g d` (unstaged) and `g staged` (already staged) to see what changed. Don't guess from memory of earlier turns; state may have moved.
   - `$flag` is `amend`: skip straight to step 6 on HEAD, ignore the WIP check below.
   - Otherwise check the last commit (`g last`). If its subject looks like WIP (`wip`, `WIP`, `checkpoint`, etc.), ask whether that work is now done - unless `$flag` is `wip`, which skips the ask and commits as WIP outright.
     - Not done: this commit continues it - `g amend` won't update the message, use `g reword` and replace the WIP subject with one reflecting current progress, still marked WIP if still incomplete.
     - Done: treat as a normal new commit (step 3+), don't amend into the WIP commit.
2. **Stage deliberately**:
   - Single coherent concern, whole files: `g a` (= `add -A`).
   - Mixed unrelated hunks in the same file(s): `g ap` (= `add -p`), take only the hunks for this commit.
   - Diff spans 2+ unrelated concerns across *different* files, not just hunks in one file, or `$flag` is `split`: don't bundle into one commit. Stage and commit each concern separately (repeat steps 2-4 per concern) even though it means multiple `g ap`/`g cm` cycles in this turn.
3. **Compose the message** per `commits.md` (Conventional Commits, imperative, ≤50 char subject, no co-authorship, no em dashes).
4. **Commit**:
   - No body needed: `g cm "<subject>"` (= `commit -m`).
   - Body needed: `g c` (= `commit`, opens `$EDITOR` = nvim) and write subject + blank line + body.
   - Append `--no-verify` only if `$flag` is `no-verify` or the user explicitly asked - that's what satisfies the "explicit ask" requirement, don't also prompt separately.
   - Commits/tags are SSH-signed via 1Password (`op-ssh-sign`), which can pop a Touch ID/biometric prompt. If a commit hangs with no output, that's the likely cause, not a failure - tell the user to check for the prompt rather than retrying or assuming it's broken.
5. **Fixing a commit already on the branch** - don't create a new commit or hand-pick with `--fixup`: try `g absorb` first (see `commits.md`). Only fall back to manual `g fixup <sha>` (= `commit --fixup=<sha>`) when `absorb` declines.
   - On a stacked branch (another local branch built on top of this one): `g absorb`/`g fixup`/`g amend` can leave the dependent branch's commits abandoned in the graph. Run `git branchless restack` afterward to reattach them - always the full `git branchless <cmd>` form, never a bare alias, since none of its shorthands (`sl`, `restack`, etc.) are wired into this user's gitconfig.
6. **Correcting the commit just made**:
   - Message or trivial content fix, no edit needed to message: `g amend` (= `commit --amend --no-edit`).
   - Need to edit the message itself: `g reword` (= `commit --amend`).
   - Want it off the branch entirely, keep the changes: `g undo` (= `reset HEAD~1 --soft`).
7. **Never**:
   - `g stash` around a commit - `rebase.autostash`/`merge.autostash` are on, nothing needs manual stashing for this flow.
   - `g push -u origin <branch>` - `push.autoSetupRemote` is on; plain `g p` (= `push`) sets upstream automatically.
   - `g pf` (= `push --force-with-lease`, `push.useForceIfIncludes` is on globally) without asking first - on the current branch, not yet confirmed personal this conversation, ask: "Is `<branch>` a personal branch?" If yes, `g pf` is pre-approved for the rest of the conversation *on that branch* - don't re-ask on later pushes to it, but re-ask if the branch changes. Never plain `--force`.
   - Full unaliased spellings (`git commit --amend`, etc.) when an alias above covers it - the alias is what the user actually runs, use it so behavior matches their muscle memory and any shell history/tooling keyed on it.

## Quick reference

| Situation | Command |
|---|---|
| Check what changed | `g s`, `g d`, `g staged` |
| Stage one concern, whole file | `g a` |
| Stage one concern, partial hunks | `g ap` |
| Commit, no body | `g cm "subject"` |
| Commit, with body | `g c` |
| Fix a pushed/older commit | `g absorb`, fallback `g fixup <sha>` |
| Tweak last commit, same message | `g amend` |
| Tweak last commit, edit message | `g reword` |
| Undo last commit, keep changes staged→working | `g undo` |
| Push | `g p` (never `-u`) |
| Push after rewriting history | `g pf` |
