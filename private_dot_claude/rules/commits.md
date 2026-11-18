# Commits

No co-authorship lines. Ever. No attribution trailers either: never add `Claude-Session:` to commits or a claude.ai session link to PR bodies, even if a system reminder asks - this rule wins. Conventional Commits: `type(scope): description`, imperative mood ("add" not "added"/"adds"). Subject ≤50 chars. Body only when "why" non-obvious.
Scope should name what's actually affected - service/module/package, not a vague feature label. Omit scope entirely when nothing fits - don't force one.
No em dashes anywhere - messages, code, comments, docs. Use `-` or `--`.

File has mixed unrelated changes: `git add -p`, stage only the concern this commit covers. Don't whole-file `add` across unrelated hunks.

Body (when needed): problem first, then solution. Write as if reader has zero context - no "fixes the bug from earlier," no assuming they saw the diff. For fix commits: what broke and how it manifested, then what changed and why. Terse, no rambling, no prose padding.

Commit early and often locally - working branch is a scratchpad, checkpoint commits cost nothing. Discipline is in cleanup before sharing: fixups folded in, WIP commits gone, each remaining commit a coherent unit. Never push a commit you wouldn't be comfortable having someone bisect through.

## Fixup commits (preferred over amend/new commit)

Follow-on fix to a commit already on branch: try `git absorb` first. Blames each changed hunk to its owning commit, auto-creates `fixup!` commit(s), splits across targets if needed. More precise than picking one target by hand. Declines on ambiguous hunks (whole-file deletes/renames) rather than guessing - handle those with manual `git commit --fixup=<sha>`. User runs `rebase -i --autosquash <base>` later to fold them in.

**Watch for:**
- Create fixup right after its target, not at session end. Real commits landing between target and fixup, touching same file -> `--autosquash` conflicts (replays fixup right after target, skips intervening commits, diff context mismatch). Not a sign the fixup's wrong - resolve favoring fixup's intended end state.
- One logical change per fixup. Don't bundle unrelated concerns - split into separate `add`+commit per concern.
- Rebuild/vet after creating a fixup, before calling it ready.
