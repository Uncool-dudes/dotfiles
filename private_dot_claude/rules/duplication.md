# Duplication

- Identical function bodies copy-pasted across modules, differing only by name/type: extract one generic function, let callers specify what differs.
- Embrace generics where you can - a single parameterized function beats N near-identical copies.
- Logic duplication is more subtle than function duplication - same business rule re-implemented in multiple services with different names/types, code looks different but encodes the same decision. When the rule changes (e.g. a threshold), missed sites silently drift out of sync.
- One domain function should own the rule; every caller computes through it, not around it.
- Concept duplication is the most dangerous form - a concept (e.g. "active user") scattered as ad-hoc conditions across modules, each expressed differently, so tooling won't flag the duplication. Sites drift independently and silently - one forgets a check, another adds its own interpretation.
- Name the concept as a single predicate/function. Every site calls it instead of re-deriving the condition. Requirements change: update one place.
- Pattern duplication: a multi-step sequence (fetch-validate-transform, etc) repeated per variant instead of extracted once. Same shape as function duplication but spans several steps, not one expression - extract the sequence as a generic, let callers supply what varies.
