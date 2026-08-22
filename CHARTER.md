# The Charter of the Vibe Proof System

*This prose mirrors `kernel/Vps/` for human readers. Where they differ, the Lean is
authoritative: the Charter's articles are the kernel's types and theorems.*

**Article 1 — Identity.** The Vibe Proof System (VPS) governs AI-assisted work by proof.
Law is code in the kernel's proof language. Citations take the form `[YEAR] VPS n`.

**Article 2 — The gate is the only law.** A rule binds if and only if it is compiled into
the statute book and enforced by the kernel gate. There is no advisory tier. Practice notes
may exist but carry no duty language and no force.

**Article 3 — Law is code.** An instrument is a typed value: citation, kind, rule,
entrenchment flag, supersession target, authority. Its rule is a decidable predicate over
the closed world model. An instrument that does not compile is not law.

**Article 4 — The authority floor.** All force descends from the genesis instrument, pinned
by sovereign digest. Every other instrument names its authorising parent, which must exist
and strictly outrank it. That every instrument in the book satisfies this is the theorem
`sovereign_floor`, checked at every build. AI runs the machinery; it is never the sovereign.

**Article 5 — Permanence and supersession.** The book is append-only. Nothing is voided or
deleted; law changes by enacting a superseding instrument, which must be of equal or higher
rank than its target — a ruling cannot repeal a statute (`supersession_respects_rank`). An
entrenched instrument cannot be superseded (`entrenched_immune`) and, once violated, always
denies (`entrenched_bites`).
Citations are never reused (`citation_unique`).

**Article 6 — Courts.** Benches of one (County), three (Council), and five (Supreme) AI
judges deliberate genuinely contested semantics. A ruling's operative content is a diff to
the statute book or a precedent entry; prose opinions are commentary and bind nothing. A
ruling that cannot be expressed as compiling law cannot bind.

**Article 7 — Res judicata.** Questions are hashed; answered questions are answered from the
precedent table, whose consistency with the gate is the theorem `res_judicata`. No question
is litigated twice.

**Article 8 — The trusted base, named.** VPS claims correctness only relative to: the Lean
toolchain and independent proof checker, the fact extractor (`gate/`), git, the CI runner,
and the sovereign's assent digest — plus, for the example vectors in `Examples.lean` only,
the Lean compiler (`native_decide`; a Phase 1 item retires this). No instrument may assert a universal negative about the
system as a duty. Unfalsifiable law is unenactable: every rule ships with a passing and a
failing example.

**Article 9 — The record is not the product.** The gate governs work. Opinions, commentary,
and history live in `record/` and impose no duties on the enforcement surface.

**Article 10 — Amendment.** The world model (`kernel/Vps/World.lean`, `Instrument.lean`) and
this Charter's entrenched articles change only by a sovereign-assented act that supersedes
the genesis-line instrument by citation — which by construction forces every proof in the
kernel to be re-established before the amended system will build.
