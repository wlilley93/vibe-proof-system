/-
The genesis instrument (Charter, Art. 4). All force descends from here.

The sovereign digest is a PARAMETER, not a constant. One engine, many jurisdictions:
each supplies the sha256 of its own signed genesis text, and its book is lawful with
respect to that digest and no other. Before this, `genesisDigest` was a `def` baked into
the shared kernel, so a downstream repository could only obtain its own genesis by editing
constitutional text — which meant every jurisdiction carried a private fork of the engine
and nothing could check that the forks still agreed.

The Charter is unchanged in substance: force still descends from one sovereign text, pinned
by digest, and self-made law is still a type error. What changed is that the digest is now
named at the point of use rather than welded into the machinery.
-/
import Vps.Instrument

namespace Vps

/-- `[2026] VPS 1` — the Charter's anchor for a jurisdiction whose signed genesis text
    hashes to `d`. Entrenched, supersedes nothing, carries no operative rule; it exists to
    be the root of every authority chain. -/
def genesisInstrument (d : String) : Instrument :=
  { cite := ⟨2026, 1⟩
  , kind := .charter
  , rule := .free
  , entrenched := true
  , supersedes := none
  , authority := .sovereign d }

end Vps
