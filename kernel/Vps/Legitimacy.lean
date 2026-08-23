/-
Legitimacy: the only way a statute book can come to exist (Charter, Art. 4-5).

`Lawful` has exactly two constructors: genesis, and enact. There is no
delete, no void, no third door. Everything the courts of v2 litigated
about record validity is unrepresentable here.
-/
import Vps.Genesis

namespace Vps

/-- Does `a`'s authority resolve against the existing book `L`, for an
    instrument of kind `k`? Sovereign authority must carry the genesis
    digest; derived authority must name a parent in the book that
    strictly outranks the child. -/
def authorityResolves (d : String) (L : List Instrument) (k : Kind) : Authority → Bool
  | .sovereign x => decide (x = d)
  | .derived p => L.any fun j => decide (j.cite = p) && decide (k.rank < j.kind.rank)

/-- Is the supersession target lawful for a superseder of kind `k`?
    `none` always is. `some c` requires that the target exists in the book
    at a rank the superseder can reach (equal or lower — a ruling cannot
    repeal a statute), and that no instrument bearing that citation is
    entrenched (Charter, Art. 5). -/
def supersessionLawful (L : List Instrument) (k : Kind) : Option Citation → Bool
  | none => true
  | some c =>
      (L.any fun t => decide (t.cite = c) && decide (t.kind.rank ≤ k.rank)) &&
      (L.all fun t => !(decide (t.cite = c) && t.entrenched))

/-- The full enactment check. -/
def authorised (d : String) (L : List Instrument) (i : Instrument) : Bool :=
  authorityResolves d L i.kind i.authority && supersessionLawful L i.kind i.supersedes

/-- The citation is unallocated in the book. -/
def fresh (L : List Instrument) (i : Instrument) : Bool :=
  L.all fun j => decide (j.cite ≠ i.cite)

/-- A lawful statute book. This inductive is the constitution's operative
    core: a book is lawful iff it is the genesis book, or a lawful book
    plus one authorised, fresh enactment. Nothing is ever removed. -/
inductive Lawful (d : String) : List Instrument → Prop where
  | genesis : Lawful d [genesisInstrument d]
  | enact {L : List Instrument} {i : Instrument} :
      Lawful d L → authorised d L i = true → fresh L i = true → Lawful d (i :: L)

end Vps
