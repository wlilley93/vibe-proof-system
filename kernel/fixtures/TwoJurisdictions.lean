import Vps.Book
namespace Control

open Vps

/-- Two jurisdictions, one engine. Each names its own sovereign digest. -/
def alpha : String := "sha256:aaaa"
def beta  : String := "sha256:bbbb"

def bookA : List Instrument := [genesisInstrument alpha]
def bookB : List Instrument := [genesisInstrument beta]

/-- POSITIVE — each is lawful under its OWN genesis. -/
theorem alpha_lawful : Lawful alpha bookA := Lawful.genesis
theorem beta_lawful  : Lawful beta  bookB := Lawful.genesis

/-- POSITIVE — sovereign_floor still holds, now relative to the jurisdiction. -/
example : ∀ i, i ∈ bookA →
    i.authority = .sovereign alpha ∨
    ∃ p j, i.authority = .derived p ∧ j ∈ bookA ∧ j.cite = p ∧ i.kind.rank < j.kind.rank :=
  sovereign_floor alpha_lawful

/-- NEGATIVE — beta cannot enact under alpha's genesis. An instrument claiming alpha's
    digest is not authorised in beta's jurisdiction: `authorised` evaluates false, so the
    enactment term cannot be built at all. -/
def forgery : Instrument :=
  { cite := ⟨2026, 2⟩, kind := .statute, rule := .free
  , entrenched := false, supersedes := none, authority := .sovereign alpha }

example : authorised beta bookB forgery = false := by decide

end Control
