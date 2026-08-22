/-
Instruments: the only shape law can take (Charter, Art. 3).
-/
import Vps.World

namespace Vps

/-- The closed rule language. Every constructor is decidable over `Facts`
    by construction, so unfalsifiable law is unrepresentable (Charter,
    Art. 8). Extending this language is an Article 10 amendment. -/
inductive Rule where
  /-- Changes to paths under `scope` are denied. -/
  | pathForbidden (scope : String)
  /-- Changes to paths under `scope` must add at least one record entry. -/
  | recordRequired (scope : String)
  /-- No operative rule (the genesis instrument; pure grants of authority). -/
  | free
deriving DecidableEq, Repr

/-- Where an instrument's force comes from (Charter, Art. 4). -/
inductive Authority where
  /-- Direct sovereign assent, pinned by digest. Only the genesis line. -/
  | sovereign (digest : String)
  /-- Derived from a strictly higher-ranked instrument already in the book. -/
  | derived (parent : Citation)
deriving DecidableEq, Repr

/-- An instrument of law. `entrenched` instruments cannot be superseded
    (theorem `entrenched_immune`). `supersedes` is the only mechanism of
    change: the book is append-only (Charter, Art. 5). -/
structure Instrument where
  cite : Citation
  kind : Kind
  rule : Rule
  entrenched : Bool
  supersedes : Option Citation
  authority : Authority
deriving DecidableEq, Repr

end Vps
