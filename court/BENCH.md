# Bench Protocol (Charter, Art. 6–7)

Courts exist for what the gate cannot decide: genuinely contested semantics, first-impression
design forks, and proposed enactments. The kernel is the clerk; the bench is the court; the
compiler is the registrar.

## Tiers

County Court — one AI judge. Everyday contested calls. Council — three judges, for appeals
and cross-cutting questions. Supreme — five judges, for constitutional questions (anything
touching `kernel/Vps/World.lean`, `Instrument.lean`, or entrenched instruments). Escalation
by permission only; no skipping.

## Procedure

1. **Question hashing.** Counsel normalises the question and computes its hash. If
   `record/precedents.json` holds the hash, the matter is disposed on citation — no sitting
   (`res_judicata` guarantees the fast path agrees with deliberation).
2. **Separation.** Counsel argues; counsel never sits. The bench decides; the bench never
   drafts the enactment it will later judge.
3. **The ruling is a diff.** The operative output of any sitting is exactly one of:
   a change to `kernel/Vps/Book.lean` (an enactment, extending `book_lawful` and
   `Examples.lean`); a precedent entry in `record/precedents.json`; or a dismissal.
   Prose opinions go to `record/` as commentary, capped at 300 words per judge, and bind
   nothing.
4. **Registrar check.** The diff must compile. A ruling the compiler rejects was never made.
   Where the enactment's rank requires sovereign assent (charter-rank, or superseding on the
   genesis line), the sovereign signs the digest before the enactment lands.
5. **Breach.** An agent that acted against the book outside the gate's reach self-reports by
   filing a question with the facts, and follows the resulting diff. The gate itself cannot
   be breached silently: that is what the theorems are for.

## Record discipline (Art. 9)

Record entries are numbered `record/NNNN.md`, at most 150 words, and state: the question,
the disposition, the diff (by commit), and nothing else. The record is history, not law.
