# Domain modeling

- Ubiquitous language: code uses the same terms the business does, one consistent vocabulary - package/type/function names read as the domain does. Business says "subscription," code says "plan record" - a translation layer exists in people's heads, bugs live there.
- Bounded contexts: the same word legitimately means different things in different parts of a system - a "customer" in billing isn't a "customer" in support. Don't build one universal model. Give each context its own model, with explicit translation at the seams - ideally an anti-corruption layer when integrating with something whose model shouldn't leak in.

## Building blocks

- Value object: immutable, defined by its attributes (money, email, tenant ID, date range). Carries its own validation - invalid values can't be constructed.
- Entity: has identity that persists as its attributes change.
- Aggregate: cluster of objects with a single root, guards a consistency boundary - invariants enforced inside the aggregate in one transaction, references between aggregates go by ID.
- Aggregate boundary matters most when referential integrity lives in app code, not DB constraints - it's what tells you where an invariant is enforced vs. where you must accept eventual consistency and design for it explicitly.

## Make illegal states unrepresentable

- Go lacks sum types - approximate the discipline anyway: distinct named types for distinct concepts (OrderID isn't UserID), unexported fields with validating constructors, separate types for states with different data (draft invoice vs. finalized) instead of one struct with nullable fields + a status string.
- Compiler rejects whole classes of bugs this way, and the model documents the lifecycle by itself.
- Model behavior, not just data. Every type a bag of exported fields with logic scattered across services means you've built a database schema in memory, not a domain model.
