# Code style

## Comments

- Why, not what. Before writing one: would a better name/extracted function kill the need? If yes, do that instead.
- Earns its place only for: intent, a constraint that forced the unusual approach, a rejected alternative + why, a non-obvious consequence of changing it.
- Keep next to the code it describes, at intent level - not implementation detail that'll rot.
- Updating a comment is part of the code change, not optional cleanup.
- Never: commented-out code (git already has it), bare `TODO`/`FIXME` with no owner/ticket/resolve-condition.
- Don't duplicate what belongs elsewhere: why-it-changed goes in the commit message, why-it-is-this-way goes in the comment, not both in one or the other.
- Cross-cutting design decisions (architecture, data model choice) go in an ADR or package doc, not a line comment - link to it from the code.
- Implementing a spec/RFC/standard: cite number + section so behavior's verifiable against the source.
- Well-named tests often explain behavior better than prose.
- A short usage example or concrete input/output often beats a paragraph of description - Go testable examples are the ideal form, compiler/test runner keep them correct so they can't go stale.
- Doc comments: lead with the point. First sentence stands alone as the summary (what `go doc`/IDE hover shows) - detail follows after.

## Control flow

- Early returns for error conditions/edge cases at function top, instead of wrapping logic in nested conditionals.
- Nesting deeper than 3 levels increases cognitive load, obscures the primary path - avoid it.
- Guard clauses first, so main logic sits at top indentation level, reads linearly top to bottom.
- Happy path last, after all validations - not buried inside a conditional branch.
- Error handling scattered across guard clauses at function entry, not across multiple `else` branches.
- Policy-mechanism separation: mechanisms are pure functions returning results (`isValid`, `applyFeature`, `formatResult`); policies are the caller's decision what to do with that result (throw, log, branch, ignore).
- Error conditions and control-flow decisions must be visible at the call site - never hide a throw/early-return/branch inside a helper that looks passive. Hidden control flow breaks reusability, since a mechanism baked with one policy can't serve a different caller's policy.
- A reader must understand what a line does without opening the called function. Side effects (DB saves, payments, emails, event publishing) each get their own visible line at the orchestration layer - that layer is the table of contents for what the system does. Don't delegate a whole workflow to one opaque function; orchestrate single-purpose calls directly. This governs call-site composition, not individual function design - functions themselves stay focused and well-named regardless.

## General

- Never summarize after file edits. Diff speaks for itself.
- No abstractions beyond task scope - see @abstractions.md for what makes an abstraction worth adding at all.
- Edits to source files, not deployed/generated.
- `go build` wins over LSP diagnostics. Pre-existing warnings unrelated to change: note as pre-existing, don't block.
- New code: `errors.Is` over `==` for sentinel comparisons.
- User rejects a generated script/tool call: fix with a small manual edit, don't regenerate the whole thing from scratch.
