# The Learnings Ledger

*Everything decided across v1 and v2 that survives into the Vibe Proof System — carried as
design decisions, never as binding citation. Per the restart rule (itself a v2 learning,
DEC-001's own principle applied to v2): only what is expressly extracted here becomes part
of the new system. Anything not listed was considered and deliberately left behind.*

Disposition legend: **THEOREM** (proved in `kernel/Vps/Proofs.lean` or `Precedent.lean`),
**TYPE** (made unrepresentable by the world model), **ARTICLE** (Charter law),
**PROTOCOL** (court/bench procedure), **PHASE n** (deferred to PLAN.md phase n),
**DROPPED** (with reason).

## Constitutional settlements

| # | Decided in v1/v2 | Disposition in VPS |
|---|---|---|
| 1 | All law derives force only from sovereign assent; AI runs the machinery but is never sovereign, may not expand its own competence, amend the assent rule, or create force from its own output (v1 CASE-LAW s.23; v2 ACT-001) | **THEOREM** `sovereign_floor` + **ARTICLE** 4. Self-authorised law is now a type error, not a forbidden act. |
| 2 | Assent resolution must be an affirmative allow-list, fail-closed; the deny-list form is void as fail-open (v1 REALM-SC 10; v2 INV-ASSENT-SOURCE-001) | **TYPE**: `Authority` has only `sovereign` (digest-checked) and `derived` (parent-checked). Absence, emptiness, unrecognised forms cannot be expressed. |
| 3 | Assent is pinned to a digest of the exact text (Bill 32 practice) | **TYPE**: `genesisDigest` in `Genesis.lean`; Charter Art. 10. |
| 4 | Entrenchment: protected provisions amendable only by a sovereign act citing them by number; machinery may not soften itself (v2 ACT-008 s.14, INV-ENTRENCHED-GATE-001) | **THEOREM** `entrenched_immune` + `entrenched_bites`. v2 needed a raw-byte scan plus a digest lock; here no lawful book can contain the offending instrument. |
| 5 | An assented record is never voided, only routed for correction (v2 VJS-ACT 10) | **TYPE**: the book is append-only; change is supersession (`Lawful` has no removal constructor). |
| 6 | No universal negative may be claimed proven; name the unprovable residue instead (v2 VJS-SC 7, `met-modulo-remainder`) | **ARTICLE** 8: the trusted base is enumerated; unfalsifiable duty language is unenactable; every rule ships a passing and failing example (`Examples.lean`). |
| 7 | Real-world law is an external supremacy floor; rulings are AI outputs, not legal instruments (v1 REALM-SC 9/PC 18) | **ARTICLE** 1 framing + README disclaimer. |

## Kernel settlements

| # | Decided in v1/v2 | Disposition in VPS |
|---|---|---|
| 8 | The kernel is deterministic: no model calls, no network in the kernel closure (v2 DEC-KERNEL-001, INV-KERNEL-001, deny.toml fence) | **TYPE**: the gate is a pure Lean function; there is no IO in `Vps/` at all. The fence needs no enforcement because effects are impossible. |
| 9 | One smart point: every front door is a thin transport over one kernel, so doors cannot drift (v2 GOAL D4; DEC-004 "kernel first, MCP second") | **TYPE**: `Main.lean` is a thin CLI over `Vps.gate`; the proved artifact and the running binary are the same compilation. |
| 10 | Every denial names its instrument; every grant carries its law source (v2 first-class fields) | **THEOREM** `every_deny_names_its_law`. |
| 11 | The kernel is clerk, not court: it applies law mechanically and never litigates by prose or searches by vibes (v2 REG-KERNEL-001, VJS.md contract) | **TYPE**: `Rule` is a closed decidable language; benches handle semantics (Art. 6). |
| 12 | Read policy by reference, never hard-code thresholds (v2 bench sizes parsed from the constitution) | **TYPE**: rank relations, entrenchment, and supersession are data on instruments, evaluated by one function — there is no second copy to drift. |
| 13 | Silent gate-weakening must be non-silent (v2 enforcement-surface digest pin) | **THEOREM**-by-construction: weakening law means changing `Book.lean` (an enactment, court-visible) or the world model (Art. 10 amendment forcing re-proof). `[2026] VPS 3` additionally denies ordinary edits under `gate/`. |
| 14 | Required CI re-running the identical gate is the trust root; local hooks are bypassable with --no-verify (v2 canon-enforce.yml) | **ARTICLE** 8 + `.github/workflows/gate.yml`: CI rebuilds the proofs, replays them through the independent checker, and runs the same binary. |
| 15 | Tests check points, not properties; velocity outran depth and shipped enforcement-path bugs (v2 kernel-spec §8) | The core properties are now **THEOREMS** over all books and all facts. Example vectors remain (Art. 8) but as falsifiability witnesses, not as the safety argument. |
| 16 | Structural ceiling: files small enough to read in full; one concern per place (v2 600-line ceiling) | **PROTOCOL** practice note. The whole kernel is ~500 lines; keep it readable in one sitting. Not duty language (see #6). |
| 17 | Fail closed on unreadable inputs or stale gate binaries (v2 hook discipline) | `Main.lean` returns nonzero on unparseable facts; `gate/pre-commit` fails closed if the build fails. |

## Court and precedent settlements

| # | Decided in v1/v2 | Disposition in VPS |
|---|---|---|
| 18 | Orders bind, opinions explain (v2 DEC-002) | **ARTICLE** 6, strengthened: a ruling binds *only* as a compiled diff to the book or a precedent entry. Prose cannot bind even "unless incorporated" — incorporation is the only mode. |
| 19 | Court hierarchy 1/3/5 judges, escalate by permission, no skipping; Court of Appeal deferred (v1 courts; v2 DEC-003) | **PROTOCOL** `court/BENCH.md`: County (1), Council (3), Supreme (5). |
| 20 | Advocate and bench must be separated; counsel argues but never decides; adoption by the proper organ is constitutive (v1 Lexby model; REALM-SC 8/PC 12) | **PROTOCOL**: counsel drafts the proposed diff; the bench decides; the sovereign assents where rank requires; the compiler is the registrar. |
| 21 | Check precedent before deliberating; a found ruling disposes of the matter with no sitting (v1 fast path) | **THEOREM** `res_judicata` + **PROTOCOL**: questions are hashed and memoised; the fast path provably agrees with deliberation. |
| 22 | One live order per issue; no self-asserted ordinals; ordinals minted over the register only; no reuse of tombstoned citations (v2 Proceedings Discipline Act s.3/s.7) | **THEOREM** `citation_unique` + `fresh` in the enactment door. Self-asserted ordinals are unrepresentable: the citation is checked at the only door. |
| 23 | Supersession/citation targets must exist — no dangling references (v2 dangling-citations omnibus) | **THEOREM** `supersession_grounded`. |
| 24 | Constitutive vs correctable defects: some failures may never be laundered by procedure (v2 constitutive codes) | **TYPE**: entrenchment is the constitutive class; `entrenched_bites` proves it cannot be silenced. Finer downgrade lattice: **PHASE 2**. |
| 25 | An agent that breaches must self-report and return to court (v1 core mechanic) | **PROTOCOL** `court/BENCH.md` §Breach. The gate makes silent breach of governed paths impossible; conduct outside the gate remains a self-report duty. |
| 26 | Decisions and logs have hard word limits; hooks stay tiny (v1/v2 VPR: 60/120-word decisions, 40-word hints) | **PROTOCOL**: record entries capped at 150 words; bench opinions capped; the record is not the product (Art. 9). |

## Operational settlements

| # | Decided in v1/v2 | Disposition in VPS |
|---|---|---|
| 27 | Prompts do not create governance capability; lawfulness comes from machinery (v2 DEC-8) | The gate is the machinery; agent prompts are **PROTOCOL** only. |
| 28 | Lifecycle: route → permit → obligations → proof → log → validate (v2 DEC-12) | **PHASE 2**, simplified: v2's permit machinery shipped a permit-closed bypass; VPS will re-derive permits as capabilities (use-limited, expiring, revocable) *only if* a real need survives Phase 1 — most of the lifecycle collapsed into the gate. |
| 29 | Directory-agnostic; one fixed anchor; bind records by role/schema/id, not ceremonial path (v2 DEC-005, ACT-007) | **PHASE 3** for federation. The skeleton uses fixed repo-relative scopes for honesty; the closed `Rule` language is where roles will live. |
| 30 | Public/private boundary is real: redaction before publication, pseudonymity for subscribers, release warrant before public push + post-push review (v1 SI 7; v2 Pseudonymity Acts 13–15, boundary scans) | **PHASE 3**: publication becomes a governed act (`pathForbidden` on publish surfaces + a publication statute). Three of v2's fifteen statutes existed to correct publication residue — evidence this belongs in the gate, not in litigation. |
| 31 | Federation: install creates a local jurisdiction; local law never overrides canon; overlays load with anti-relaxation (v2 ACT-007, overlay loader) | **PHASE 3**: subscriber books = additional enactments on the genesis line; anti-relaxation becomes a theorem about the overlay join, in the same style as `entrenched_immune`. |
| 32 | Brownfield: treat the old system as requirements, build green (v1 README doctrine) | This restart is that doctrine applied to VJS itself. |
| 33 | Actor must be stated; the reader never supplies a missing actor (v2 Proceedings Discipline s.10) | **PHASE 2**: `Facts` gains an `actor` field when permits arrive; absent actor fails closed. |
| 34 | A signed instrument must not be able to read "draft" (v2 warrant-signed-but-draft defect class, CC-VJS 20) | **TYPE** philosophy applied everywhere: status is not a string field; an instrument in the book *is* in force. Lifecycle states, if ever needed, become sum types. |

## Deliberately dropped

| Decided in v1/v2 | Why dropped |
|---|---|
| The conformance map, triage registry, and banked ratchet (v2) | Accounting for an enforcement gap; the gap cannot exist under Art. 2 (no advisory tier). |
| Lock files: install.lock, lawpack.lock, conformance.lock, enforcement-surface.lock (v2) | Watchers watching watchers. Replaced by compilation + the independent proof checker. |
| The Gazette as a governed enforcement surface (v1/v2) | Art. 9: the record is not the product. Publish what you like from `record/`; it binds nothing. |
| `met-modulo-remainder` as a runtime status (v2 SC-7) | The *lesson* (name the residue) became Art. 8; the status itself is unnecessary once unfalsifiable law is unenactable. |
| The Executive Rectification Commission, residue-correction acts (v2 12, 14, 15) | Entire organs whose only jurisdiction was cleaning up the record. Nothing to rectify if defective records cannot compile. |
| Word-of-the-court style rules (em-dash bans, bracket rulings) | Formatting is a linter's job, not a court's. |
