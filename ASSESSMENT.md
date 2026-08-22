# Assessment: why VJS v1 and v2 ate themselves, and what the restart must do differently

*2026-08-22. This document is evidence and diagnosis only. Nothing from v1 or v2 — no law,
no records, no code — is inherited by the Vibe Proof System. This is a clean restart.*

## What v1 and v2 were

**v1** was case-law-first: a markdown realm (Constitution, Legislature, Judicature, Executive
ministries, ~324 files) with AI courts, Lexby as counsel, and a JS CLI for gazette publishing.
It was generative and produced real doctrine, but the law was prose. Nothing was enforced by
machine; the record grew without teeth.

**v2** was computer-first: a Rust kernel (9 crates, ~35,600 LOC, 429 tests) sitting at the git
commit chokepoint, with a YAML lawpack (statutes, regulations, orders, invariants, provenance),
digest-pinned enforcement surfaces, an entrenched assent floor, and required CI as the trust
root. The kernel ideas were sound and several were excellent.

## The failure pattern

The user's instinct — "rulings and legislation trip over themselves to re-verify the system's
integrity" — is measurably correct:

**1. Self-litigation became the workload.** Of roughly 46 opinions and judgments in the v2
lawpack, essentially all are about VJS's own machinery: its jurisdiction (PC 1, PC 6, PC 8),
its citation form (PC 4, PC 17), the construction of its own assent (PC 7, PC 16), its
publication gates (PC 2, PC 3), warrant lifecycle defects (CC-VJS 20, twenty-two numbered
defects in one case), whether a bracket is a word, whether a signed warrant that reads "draft"
is signed. The system litigated itself almost exclusively. Governed work barely appears in the
record.

**2. Law outran enforcement, then accounting for the gap became more law.** The conformance
map records 399 duties of which 240 were unwired — and the map itself, the triage registry,
the ratchet that banks triage progress, and the reserved "single front door instrument" to
process the backlog are all *additional machinery whose only subject is the gap*. Meta-work
compounding on meta-work.

**3. Integrity was operational, not structural.** v2 kept itself honest with locks
(install.lock, lawpack.lock, conformance.lock, enforcement-surface.lock), sweeps, boundary
scans, digest pins, and ratchets — mechanisms watching mechanisms. Every new rule added
surface that itself needed watching, so re-verification work grew roughly with the square of
the law. Each defect in a watcher was cured by adding another watcher, by court order. That
is the treadmill the restart must step off.

**4. The enforcement path still shipped bugs.** Permit-closed bypass, a binding order
mislabelled not-in-force, a subscriber name leaking through the redaction boundary, a gate
that shipped disarmed. 429 tests did not make the kernel flawless, because tests check points,
not properties.

**5. Unfalsifiable law caused constitutional crises.** An invariant containing a universal
negative ("no path around it") could never be proven, and resolving how to *record* that took
a full constitutional sitting which had to invent a new status. Law that cannot be checked
should never have been enactable.

## What was right and survives as ideas (not as law)

Single deterministic gate, fail-closed, no model calls in the kernel. Every denial names its
instrument. Entrenchment that machinery cannot soften. The constitutive-vs-correctable
distinction. Assented records routed for correction, never voided. Required CI re-running the
identical gate as the trust root. Honesty about the trusted residue. These were the kernel
working. They return in the restart in stronger form.

## The Lean 4 assessment

The question was whether Lean 4 is useful here. The answer is that Lean is not a useful
*addition* — it is the correct *substrate*, and it dissolves failure modes 1–5 rather than
mitigating them:

- **Law as code in the proof language.** A statute in the restart is a Lean definition: a
  decidable predicate over a closed world model, carrying an authority reference. The statute
  book is a Lean module. An inconsistent, unauthorised, ill-formed, or unfalsifiable statute
  *does not compile*. The entire class of self-litigation about record validity, citation
  collisions, assent construction, and contradictory canon becomes unrepresentable.
- **Proofs replace watchers.** Non-relaxation, entrenchment permanence, citation uniqueness,
  the authority floor: in v2 each was a lock file plus tests plus a sweep. Here each is a
  theorem about the only transition function law can pass through, checked at every build.
  The O(n²) re-verification treadmill collapses to one `lake build`.
- **Self-legitimising, literally.** The book's lawful derivation from the genesis instrument
  is itself a theorem (`book_lawful`) that the compiler checks. The system never *performs*
  integrity verification as an activity; integrity is a property of the artifact.
- **"Flawless kernel", stated honestly.** Lean compiles to native code, so the *proved
  artifact is the running gate* — no model/implementation gap. Proofs are replayed by an
  independent checker (`lean4checker`; Lean's own metatheory is mechanized in Lean4Lean).
  Pinned to the toolchain the kernel was verified on (v4.15.0 — see record/0004.md); the
  pin moves only together with full re-verification. What remains trusted is
  enumerated, finite, and named in the Charter: the Lean toolchain and checker, the fact
  extractor, the CI runner, git, and the sovereign key. No universal negatives are claimed —
  that lesson is now Charter law: *unfalsifiable law is unenactable*.

**Why not Rust kernel + Lean model on the side:** a separate formal model must be kept in
correspondence with the implementation — which is precisely a new watcher watching a watcher,
the disease we are curing. The model must be the machine.

**Costs accepted:** slower plumbing iteration than Rust; a thin trusted shell layer for fact
extraction (kept deliberately dumb and property-testable); proofs must be maintained when the
world model changes — which is a feature: changing the constitution *should* force re-proof.

## The mechanism, relitigated (the restart's principles)

1. **Closed world.** A fixed set of record kinds and transitions, defined as types. New kinds
   require amending the world model — a constitutional act that forces recompilation of every
   proof.
2. **One gate, no advisory tier.** A rule is enforced or it is not law. Practice notes exist
   but carry zero force and no duty language. The wired/unwired ledger cannot exist here.
3. **Enactment = compilation + authority proof.** Force flows only from the genesis
   instrument through typed authority references, strictly rank-descending. Self-authorised
   law is a type error.
4. **The record is append-only; change is supersession.** Nothing is voided or deleted.
   Entrenched instruments cannot be superseded — a theorem, not a lock file.
5. **A ruling binds only as a diff to the book.** Courts (benches of 1/3/5) deliberate
   genuinely contested semantics, but a ruling's operative content is a compiled change to
   law or a precedent entry keyed by question hash. Prose opinions are commentary. A ruling
   that cannot be expressed as law-code cannot bind — so enforcement can never drift from
   doctrine.
6. **Res judicata by construction.** Precedent is a memo table over question hashes; the
   consistency of table with gate is a theorem. The same question is never litigated twice.
7. **Every rule ships falsifiable.** Enactment requires a passing and a failing example
   (compile-time test vectors). Universal negatives about the system are Charter-barred from
   duty language.
8. **The record is not the product.** The gate governs work. The museum (opinions, gazette)
   lives outside the governed enforcement surface and imposes no duties.

## Verdict

The kernel concept works; both prior substrates were wrong. v1 had law without a machine;
v2 had a machine that needed ever more law to trust itself. The restart makes the trust
question closed-form: one small world, one transition function, theorems instead of watchers,
and a compiler standing where the courts used to queue. See PLAN.md for the build plan and
`kernel/` for the working core.
