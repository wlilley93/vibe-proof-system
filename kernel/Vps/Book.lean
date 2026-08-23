/-
THE STATUTE BOOK (Charter, Art. 3).

This module is the law. Enacting is: add an instrument here, cons it onto
`theBook`, and extend `book_lawful` by one `.enact` step. If the authority
chain does not resolve, the citation is not fresh, or the supersession is
unlawful, `book_lawful` fails to compile and the enactment does not exist.

Every instrument must also register a passing and a failing example in
`Examples.lean` (Charter, Art. 8: unfalsifiable law is unenactable).
-/
import Vps.Legitimacy
import Vps.Proofs

namespace Vps

/-- `[2026] VPS 2` — Kernel Protection Act. Changes under `kernel/` must
    carry a record entry explaining themselves. Entrenched. -/
def actKernelProtection : Instrument :=
  { cite := ⟨2026, 2⟩
  , kind := .statute
  , rule := .recordRequired "kernel/"
  , entrenched := true
  , supersedes := none
  , authority := .derived ⟨2026, 1⟩ }

/-- `[2026] VPS 3` — Gate Integrity Act. The gate's hook scripts are not
    editable through ordinary work: changes under `gate/` are denied and
    must instead arrive by enactment (a superseding instrument shipping
    with the change that relaxes or amends this act lawfully). -/
def actGateIntegrity : Instrument :=
  { cite := ⟨2026, 3⟩
  , kind := .statute
  , rule := .pathForbidden "gate/"
  , entrenched := false
  , supersedes := none
  , authority := .derived ⟨2026, 1⟩ }

/-- `[2026] VPS 4` — Record Discipline Act. Changes to the law's prose
    mirror and commentary (`law/`) must add a record entry. -/
def actRecordDiscipline : Instrument :=
  { cite := ⟨2026, 4⟩
  , kind := .statute
  , rule := .recordRequired "law/"
  , entrenched := false
  , supersedes := none
  , authority := .derived ⟨2026, 1⟩ }

/-- **This jurisdiction's sovereign digest.** The engine is parameterised by it (see
    `Genesis.lean`); a jurisdiction names its own here, once, and every theorem below is
    then about THIS book under THIS genesis and no other. Replace with the sha256 of the
    signed genesis text at first real enactment, and thereafter only by an Article 10
    amendment — which by construction forces every proof in the kernel to be re-established
    before the amended system will build. -/
def digest : String := "sha256:GENESIS-PLACEHOLDER-PIN-ME"

/-- The book, newest first. -/
def theBook : List Instrument :=
  [actRecordDiscipline, actGateIntegrity, actKernelProtection, genesisInstrument digest]

/-- **The book's legitimacy is a compile-time theorem.** An unlawful book
    does not build: this term IS the system verifying its own integrity,
    once, structurally, instead of forever, operationally. -/
theorem book_lawful : Lawful digest theBook :=
  Lawful.enact
    (Lawful.enact
      (Lawful.enact
        Lawful.genesis
        (by decide) (by decide))
      (by decide) (by decide))
    (by decide) (by decide)

/-- The gate as actually deployed: the compiled book applied to facts. -/
def gate (f : Facts) : Verdict :=
  decideVerdict theBook f

end Vps
