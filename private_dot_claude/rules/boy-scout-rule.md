# Boy scout rule

- Leave code better than found - but confine improvements to code actually being modified for the task.
- Opportunistic refactoring: small cleanups bundled into the task work, not a separate effort. Stop when the improvement diverges from the current change.
- Scope creep disguised as cleanup violates YAGNI, complicates review/testing/reverting - avoid it.
- When touching a function, appropriate: rename unclear variables, add missing type annotations, extract small helpers, remove dead code, fix obvious smells.
- When fixing a bug or adding a feature, not appropriate: restructuring whole modules, introducing new design patterns, refactoring unrelated files, replacing working implementations with "better" alternatives.
- Keep changes adjacent and related to the primary task - e.g. fixing a null-check bug, rename the one confusing variable involved, don't rewrite the module's architecture.
