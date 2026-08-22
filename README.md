# Vibe Proof System

*Governance for AI-assisted work, by proof. Spec is law. Law is code. Legitimacy is a
theorem. Not a real court; not legal advice.*

A clean restart of the Vibe Justice System line. v1 had law without a machine; v2 had a
machine that needed ever more law to trust itself — its own courts spent their docket
re-verifying the system's integrity. VPS closes that loop structurally: the statute book is
Lean 4 code, the gate is a proved pure function compiled to the very binary that runs in
your pre-commit hook, and the properties v2 enforced with locks, sweeps, and ratchets are
theorems replayed by an independent checker on every build.

- **CHARTER.md** — the constitution (prose mirror; the Lean is authoritative)
- **ASSESSMENT.md** — why v1 and v2 ate themselves; the Lean 4 decision
- **LEARNINGS.md** — every v1/v2 settlement, carried forward or deliberately dropped
- **PLAN.md** — the build phases
- **kernel/** — the kernel: world model, legitimacy door, gate, theorems, statute book
- **gate/** — the pre-commit wall (trusted, dumb) · **.github/workflows/gate.yml** — trust root
- **court/** — bench protocol · **record/** — history, not law · **law/** — prose mirrors

## The one-line theory

Illegal states are unrepresentable, illegal transitions are unprovable, and therefore
integrity is a property the system *has*, not an activity it *performs*.

## Quickstart

```
cd kernel && lake build     # compiles the law; checks every proof
sh gate/install.sh          # points git at the gate
lake exe vps book           # the statute book, whose legitimacy compiled
```

Key theorems (`kernel/Vps/Proofs.lean`): `sovereign_floor` (no self-made law),
`citation_unique`, `supersession_grounded`, `supersession_respects_rank`,
`entrenched_immune`, `entrenched_bites`
(entrenched law cannot be silenced), `every_deny_names_its_law`, `res_judicata`
(precedent never disagrees with deliberation), and `book_lawful` — the statute book's own
legitimacy, established by the compiler.
