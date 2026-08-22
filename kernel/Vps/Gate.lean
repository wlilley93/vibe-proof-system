/-
The gate (Charter, Art. 2): the single decision function.

Deterministic and total by construction: it is a function. Every denial
names its instruments (theorem `every_deny_names_its_law` in Proofs.lean).
-/
import Vps.Legitimacy

namespace Vps

inductive Verdict where
  | allow
  | deny (cites : List Citation)
deriving DecidableEq, Repr

/-- Does the proposed change violate this instrument's rule? -/
def violated (f : Facts) (i : Instrument) : Bool :=
  match i.rule with
  | .pathForbidden s => f.pathsChanged.any fun p => s.isPrefixOf p
  | .recordRequired s =>
      (f.pathsChanged.any fun p => s.isPrefixOf p) && decide (f.recordsAdded = 0)
  | .free => false

/-- Only effective (unsuperseded) instruments bite. -/
def effectiveB (L : List Instrument) (i : Instrument) : Bool :=
  L.all fun j => decide (j.supersedes ≠ some i.cite)

/-- The gate. Filters the book down to effective, violated instruments;
    allows iff that list is empty, otherwise denies citing every one. -/
def decideVerdict (L : List Instrument) (f : Facts) : Verdict :=
  match L.filter (fun i => effectiveB L i && violated f i) with
  | [] => .allow
  | v :: vs => .deny ((v :: vs).map (·.cite))

end Vps
