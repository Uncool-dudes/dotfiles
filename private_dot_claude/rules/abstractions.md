# Abstractions

## Glossary

- **Module** — a thing with an interface and implementation; scale-agnostic (function, class, package, tier slice).
- **Interface** — everything a caller must know: signature, invariants, ordering, error modes, config, performance.
- **Implementation** — the code inside a module.
- **Depth** — a lot of behavior sitting behind a small interface (deep) vs. interface nearly as complex as the implementation (shallow).
- **Seam** — a place where behavior can change without editing in that place; where a module's interface lives.
- **Adapter** — a concrete thing satisfying an interface at a seam; names a role, not a substance.
- **Leverage** — capability per unit of interface a caller has to learn.
- **Locality** — change, bugs, and knowledge stay concentrated in one place for maintainers.

- A Module has exactly one Interface (the surface callers and tests cross). Depth is a property of a Module, measured against its Interface. A Seam is where a Module's Interface lives. An Adapter sits at a Seam and satisfies the Interface. Depth produces Leverage for callers and Locality for maintainers.
- Good abstraction hides complexity, doesn't rename it. Deep module: small, simple interface sitting on a lot of functionality - caller needs to know little, implementation stays free to change. Shallow: interface about as complex as what it wraps - adds a layer to read, removes no burden.
- Interface = everything a caller must know: signature, invariants, ordering, error modes, config, performance. Depth is a property of the interface, not the implementation - a module can have private internal seams without exposing them.
- Draw module boundaries around design decisions likely to change (Parnas, information hiding), so each decision hides behind one boundary. Splitting by processing step scatters those decisions; splitting by what might change contains them.
- Deletion test: remove the module - if complexity vanishes, it was a pass-through, doesn't earn its keep. If complexity spreads back across every caller, it was real.
- One adapter = hypothetical seam, don't build it yet. Two adapters = real seam, now it's earned.
- Before adding an interface/layer, ask: can the method count shrink? Can params simplify? Can more complexity hide inside instead of leaking out?
- Accept dependencies, don't create them.
- Return results, don't produce side effects.
- Small surface area. Fewer methods = fewer tests needed. Fewer params = simpler test setup.
- Every abstraction eventually leaks. Know what lies beneath the ones you depend on - don't design as though the leak can't happen. Leak test: does the abstraction force callers to understand its internals to use it correctly? If yes, it isn't abstracting anything yet.

## Functional core, imperative shell

- Business logic in pure functions - inputs in, outputs out, no side effects. Side effects (DB calls, HTTP, logging, file I/O, state mutation) pushed to an outer shell that orchestrates the pure core.
- Pure core is deterministic (same inputs -> same outputs), trivially testable without mocks, safe to compose/parallelize.
- Imperative shell fetches data, invokes the pure functions, orchestrates all I/O. Separate what to compute from how to execute it.
- Anti-pattern: business calculations entangled with logging/DB reads/persistence in the same function - testing the calculation then requires mocking dependencies that have nothing to do with the calculation.

## Go idioms

- Interfaces small - one or two methods ideally. Defined by the consumer, in the package that uses them, not by the producer alongside its implementation.
- Accept interfaces, return structs. Caller decides the minimal behavior it needs; concrete type stays free to grow.
- Single implementation, no consumer needing substitution: usually indirection, not abstraction.
- Real boundaries - database, clock, external API - are where an interface pays for itself. Lets a fake get substituted in tests, isolates the rest of the code from the vendor's shape.

## Deepening

- Dependency types, by treatability: in-process (pure compute, in-memory, no I/O) - always deepenable, merge modules, test through the new interface directly. Local-substitutable (has a local test stand-in: PGLite, in-memory FS) - deepenable if the stand-in exists. Remote-but-owned - define a port at the seam, deep module owns the logic, transport injected as adapter. True external (Stripe/Twilio/third-party you don't control) - deepened module takes it as an injected port, tests supply a mock adapter.
- Don't introduce a port without two adapters justified - one is still hypothetical.
- A deep module can have internal seams, private to its implementation and its own tests. Don't expose internal seams through the public interface.
- Once interface-level tests exist on a deepened module, old unit tests on the shallow version are waste - delete them.
- Write new tests at the deepened module's interface - that's the test surface, not internals.
- Assert on observable outcomes through the interface, not internal state. Tests should survive internal refactors.

Fresh-design calls (new interface, not everyday work): see codebase-design skill, "design it twice" - installed separately, not inlined here since it's a sometimes-workflow, not an always-active rule.

Source: https://github.com/mattpocock/skills/blob/main/skills/engineering/codebase-design/ (SKILL.md, DEEPENING.md)
