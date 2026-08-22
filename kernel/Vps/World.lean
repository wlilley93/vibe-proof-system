/-
The closed world model (Charter, Art. 1 and 10).

This file IS constitutional text. Changing it is an Article 10 amendment:
every proof in the kernel must re-establish before the system builds again.
-/
namespace Vps

/-- The closed set of record kinds. There is no way to introduce a new kind
    of law at runtime; a new kind is an amendment to this type. -/
inductive Kind where
  | charter
  | statute
  | ruling
  | note
deriving DecidableEq, Repr

/-- Rank: who may authorise whom. A parent must strictly outrank its child
    (see `Legitimacy.authorityResolves`). Notes have no rank and can
    therefore authorise nothing. -/
def Kind.rank : Kind → Nat
  | .charter => 3
  | .statute => 2
  | .ruling  => 1
  | .note    => 0

/-- A citation: `[year] VPS ordinal`. Allocation is proven fresh at
    enactment (`citation_unique`). -/
structure Citation where
  year : Nat
  ordinal : Nat
deriving DecidableEq, Repr

/-- What the trusted fact extractor (`gate/`) asserts about a proposed
    change. This structure is the entire interface between the world and
    the kernel: the extractor is part of the named trusted base
    (Charter, Art. 8), so it is kept deliberately small and dumb. -/
structure Facts where
  /-- Repository paths touched by the staged change. -/
  pathsChanged : List String
  /-- Number of new record entries the change adds under `record/`. -/
  recordsAdded : Nat
deriving DecidableEq, Repr

end Vps
