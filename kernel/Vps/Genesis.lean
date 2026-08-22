/-
The genesis instrument (Charter, Art. 4). All force descends from here.
-/
import Vps.Instrument

namespace Vps

/-- The sovereign assent digest. At first real enactment, replace with the
    sha256 of the signed genesis text and never change it except by an
    Article 10 amendment. -/
def genesisDigest : String :=
  "sha256:GENESIS-PLACEHOLDER-PIN-ME"

/-- `[2026] VPS 1` — the Charter's anchor. Entrenched, supersedes nothing,
    carries no operative rule; it exists to be the root of every authority
    chain. -/
def genesisInstrument : Instrument :=
  { cite := ⟨2026, 1⟩
  , kind := .charter
  , rule := .free
  , entrenched := true
  , supersedes := none
  , authority := .sovereign genesisDigest }

end Vps
