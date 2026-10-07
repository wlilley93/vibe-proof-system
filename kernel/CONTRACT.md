# VPS module contract v1.0.0

## Identity and revision pins

This is contract **v1.0.0**, a snapshot of the reusable VPS engine's source
interface and Lean-elaborated theorem statements at the following pins. It is
not a claim about an unpinned later revision.

| Item | Pin |
| --- | --- |
| Package | `vps` |
| Library / namespace | `Vps` |
| Package directory | `kernel` |
| Kernel source SHA | `5e44b9e11554515e10271d742eb6d1929de479e1` |
| Lean toolchain | `leanprover/lean4:v4.33.1` |

Package identity comes from `kernel/lakefile.toml`; the toolchain comes from
`kernel/lean-toolchain`. Paths below are repository-relative. The source SHA
identifies the code described, not the later commit adding this document.

## Reusable engine boundary

The engine consists of these seven modules. All declarations below are in
namespace `Vps`; module names are import paths, not nested namespaces (for
example, `Vps.Lawful`, not `Vps.Legitimacy.Lawful`).

| Module | Responsibility | Direct engine import |
| --- | --- | --- |
| `Vps.World` | Closed record kinds and ranks, citation identity, and the fact-extractor input shape. | None |
| `Vps.Instrument` | Closed rule and authority languages and the instrument record, including list-valued supersession. | `Vps.World` |
| `Vps.Genesis` | Construct the entrenched genesis anchor for a supplied sovereign digest. | `Vps.Instrument` |
| `Vps.Legitimacy` | Check authority, supersession and citation freshness; define lawful books by genesis and enactment only. | `Vps.Genesis` |
| `Vps.Gate` | Compute rule violations, effectiveness and the deterministic allow/deny verdict with citations. | `Vps.Legitimacy` |
| `Vps.Proofs` | Prove authority, supersession, uniqueness, entrenchment and denial-naming properties. | `Vps.Gate` |
| `Vps.Precedent` | Define precedent-table soundness and lookup, and prove that sound lookup agrees with its oracle. | `Vps.Gate` |

The digest is an explicit parameter to genesis, legitimacy and the relevant
proofs. The reusable engine does not select a jurisdiction's digest or enact
its statutes. `Instrument.supersedes` is `List Citation`, not an optional
single citation: one instrument may retire many instruments.

### Jurisdiction-specific modules (not reusable engine)

- **`Vps.Book`** (`kernel/Vps/Book.lean`) supplies this repository's `digest`,
  three statutes, `theBook`, the concrete proof `book_lawful`, and the deployed
  wrapper `gate`. Its digest is a placeholder at this pin, not an assertion
  that signed genesis text has been provisioned. `Vps.book_lawful` is included
  in the required output below as a concrete jurisdiction proof, not a tenth
  generic engine theorem.
- **`Vps.Examples`** (`kernel/Vps/Examples.lean`) imports `Vps.Book` and supplies
  five anonymous compile-time example vectors for that book. These use
  `native_decide`; they are not the reusable safety proofs in `Vps.Proofs`.
- **`Vjs.Book`** is the downstream VJS consumer's jurisdiction-specific book,
  not a module of this kernel or part of the seven-module reusable engine.
  Its role is to supply the consumer's own law over the pinned engine. Its
  source and signatures are not present in this repository and are not
  independently verified or pinned by this contract.

The umbrella module `kernel/Vps.lean` imports all seven engine modules **and**
`Vps.Book` and `Vps.Examples`. Thus `import Vps`, used for the measurement below,
loads this repository's jurisdiction as well. Consumers wanting only the
reusable engine should import the engine modules they need rather than treat
all exports of that umbrella as jurisdiction-neutral.

## Pinned source signatures

The following excerpts preserve the baseline's declaration names, binder
order, implicit/explicit binders, types, constructors, record fields and
`deriving` clauses. They are read in `namespace Vps` with the module imports
listed above. Source comments are omitted. Small definitions are reproduced
with their bodies; theorem excerpts stop immediately before `:= by` and omit
proof bodies. Compiler-generated projections, recursors and derived instances
are determined by the displayed declarations and pinned toolchain, rather
than separately enumerated here.

### `Vps.World`

Source: `kernel/Vps/World.lean`.

```lean
inductive Kind where
  | charter
  | statute
  | ruling
  | note
deriving DecidableEq, Repr

def Kind.rank : Kind → Nat
  | .charter => 3
  | .statute => 2
  | .ruling  => 1
  | .note    => 0

structure Citation where
  year : Nat
  ordinal : Nat
deriving DecidableEq, Repr

structure Facts where
  pathsChanged : List String
  recordsAdded : Nat
deriving DecidableEq, Repr
```

### `Vps.Instrument`

Source: `kernel/Vps/Instrument.lean`.

```lean
inductive Rule where
  | pathForbidden (scope : String)
  | recordRequired (scope : String)
  | free
deriving DecidableEq, Repr

inductive Authority where
  | sovereign (digest : String)
  | derived (parent : Citation)
deriving DecidableEq, Repr

structure Instrument where
  cite : Citation
  kind : Kind
  rule : Rule
  entrenched : Bool
  supersedes : List Citation
  authority : Authority
deriving DecidableEq, Repr
```

### `Vps.Genesis`

Source: `kernel/Vps/Genesis.lean`.

```lean
def genesisInstrument (d : String) : Instrument :=
  { cite := ⟨2026, 1⟩
  , kind := .charter
  , rule := .free
  , entrenched := true
  , supersedes := []
  , authority := .sovereign d }
```

### `Vps.Legitimacy`

Source: `kernel/Vps/Legitimacy.lean`.

```lean
def authorityResolves (d : String) (L : List Instrument) (k : Kind) : Authority → Bool
  | .sovereign x => decide (x = d)
  | .derived p => L.any fun j => decide (j.cite = p) && decide (k.rank < j.kind.rank)

def supersessionLawful (L : List Instrument) (k : Kind) (cs : List Citation) : Bool :=
  cs.all fun c =>
    (L.any fun t => decide (t.cite = c) && decide (t.kind.rank ≤ k.rank)) &&
    (L.all fun t => !(decide (t.cite = c) && t.entrenched))

def authorised (d : String) (L : List Instrument) (i : Instrument) : Bool :=
  authorityResolves d L i.kind i.authority && supersessionLawful L i.kind i.supersedes

def fresh (L : List Instrument) (i : Instrument) : Bool :=
  L.all fun j => decide (j.cite ≠ i.cite)

inductive Lawful (d : String) : List Instrument → Prop where
  | genesis : Lawful d [genesisInstrument d]
  | enact {L : List Instrument} {i : Instrument} :
      Lawful d L → authorised d L i = true → fresh L i = true → Lawful d (i :: L)
```

`supersessionLawful` checks every citation in the list; the empty list passes.
The baseline's nearby prose still mentions `none` / `some c`, but the pinned
signature and implementation above are list-valued and authoritative.

### `Vps.Gate`

Source: `kernel/Vps/Gate.lean`.

```lean
inductive Verdict where
  | allow
  | deny (cites : List Citation)
deriving DecidableEq, Repr

def violated (f : Facts) (i : Instrument) : Bool :=
  match i.rule with
  | .pathForbidden s => f.pathsChanged.any fun p => s.isPrefixOf p
  | .recordRequired s =>
      (f.pathsChanged.any fun p => s.isPrefixOf p) && decide (f.recordsAdded = 0)
  | .free => false

def effectiveB (L : List Instrument) (i : Instrument) : Bool :=
  L.all fun j => decide (i.cite ∉ j.supersedes)

def decideVerdict (L : List Instrument) (f : Facts) : Verdict :=
  match L.filter (fun i => effectiveB L i && violated f i) with
  | [] => .allow
  | v :: vs => .deny ((v :: vs).map (·.cite))
```

### `Vps.Proofs`

Source: `kernel/Vps/Proofs.lean`. These are the eight source theorem headers,
with no strengthening or removal of hypotheses. In particular,
`every_deny_names_its_law` does not require a `Lawful` hypothesis and states
that a denial's citation list is nonempty.

```lean
theorem sovereign_floor {d : String} {L : List Instrument} (h : Lawful d L) :
    ∀ i, i ∈ L →
      i.authority = .sovereign d ∨
      ∃ p j, i.authority = .derived p ∧ j ∈ L ∧ j.cite = p ∧ i.kind.rank < j.kind.rank

theorem supersession_grounded {d : String} {L : List Instrument} (h : Lawful d L) :
    ∀ i, i ∈ L → ∀ c, c ∈ i.supersedes → ∃ t, t ∈ L ∧ t.cite = c

theorem citation_unique {d : String} {L : List Instrument} (h : Lawful d L) :
    ∀ i, i ∈ L → ∀ j, j ∈ L → i.cite = j.cite → i = j

theorem supersession_respects_rank {d : String} {L : List Instrument} (h : Lawful d L) :
    ∀ j, j ∈ L → ∀ c, c ∈ j.supersedes →
    ∀ t, t ∈ L → t.cite = c → t.kind.rank ≤ j.kind.rank

theorem entrenched_immune {d : String} {L : List Instrument} (h : Lawful d L) :
    ∀ e, e ∈ L → e.entrenched = true →
    ∀ j, j ∈ L → e.cite ∉ j.supersedes

theorem entrenched_effective {d : String} {L : List Instrument} (h : Lawful d L) :
    ∀ e, e ∈ L → e.entrenched = true → effectiveB L e = true

theorem every_deny_names_its_law {L : List Instrument} {f : Facts} {cs : List Citation}
    (h : decideVerdict L f = .deny cs) : cs ≠ []

theorem entrenched_bites {d : String} {L : List Instrument} {f : Facts} {e : Instrument}
    (h : Lawful d L) (he : e ∈ L) (hent : e.entrenched = true)
    (hv : violated f e = true) :
    ∃ cs, decideVerdict L f = .deny cs ∧ e.cite ∈ cs
```

### `Vps.Precedent`

Source: `kernel/Vps/Precedent.lean`.

```lean
structure Precedent where
  question : String
  verdict : Verdict
deriving DecidableEq, Repr

def Sound (table : List Precedent) (oracle : String → Verdict) : Prop :=
  ∀ p, p ∈ table → oracle p.question = p.verdict

def answer (table : List Precedent) (oracle : String → Verdict) (q : String) : Verdict :=
  match table.find? (fun p => decide (p.question = q)) with
  | some p => p.verdict
  | none => oracle q

theorem res_judicata {table : List Precedent} {oracle : String → Verdict} {q : String}
    (hs : Sound table oracle) : answer table oracle q = oracle q
```

`res_judicata` is conditional on `Sound table oracle`; it does not establish
that arbitrary stored answers or question hashes are sound.

## Elaborated-statement output

This output was generated from the pinned code, not transcribed from a
requirements ticket. The scratch input was outside the repository, in a
fresh directory created with `mktemp -d`. From the worktree's `kernel/`
directory, the measurement commands were:

```sh
lake env lean --version
lake build Vps
lake env lean /var/folders/d3/kjqpj9f92m751wdg7rsnn56c0000gn/T/tmp.tlpqhqDSmW/Contract.lean > /var/folders/d3/kjqpj9f92m751wdg7rsnn56c0000gn/T/tmp.tlpqhqDSmW/Contract.out
```

The version command printed:

```text
Lean (version 4.33.1, arm64-apple-darwin24.6.0, commit 819816b2e0a3bf405af45ae5c7af2491d8f5bee6, Release)
```

`lake build Vps` completed successfully (12 jobs); elaboration exited with
status 0. The exact scratch input follows. To reproduce, create a new
`mktemp -d` directory outside the repository, save this as `Contract.lean`
there, build `Vps`, and run `lake env lean <scratch>/Contract.lean` from
`kernel/`. The temporary pathname is not part of the interface pin.

```lean
import Vps

#check Vps.sovereign_floor
#print axioms Vps.sovereign_floor
#check Vps.supersession_grounded
#print axioms Vps.supersession_grounded
#check Vps.citation_unique
#print axioms Vps.citation_unique
#check Vps.supersession_respects_rank
#print axioms Vps.supersession_respects_rank
#check Vps.entrenched_immune
#print axioms Vps.entrenched_immune
#check Vps.entrenched_effective
#print axioms Vps.entrenched_effective
#check Vps.every_deny_names_its_law
#print axioms Vps.every_deny_names_its_law
#check Vps.entrenched_bites
#print axioms Vps.entrenched_bites
#check Vps.res_judicata
#print axioms Vps.res_judicata
#check Vps.book_lawful
#print axioms Vps.book_lawful
```

Verbatim standard output, including all ten axiom reports:

```text
Vps.sovereign_floor {d : String} {L : List Vps.Instrument} (h : Vps.Lawful d L) (i : Vps.Instrument) :
  i ∈ L →
    i.authority = Vps.Authority.sovereign d ∨
      ∃ p j, i.authority = Vps.Authority.derived p ∧ j ∈ L ∧ j.cite = p ∧ i.kind.rank < j.kind.rank
'Vps.sovereign_floor' depends on axioms: [propext, Quot.sound]
Vps.supersession_grounded {d : String} {L : List Vps.Instrument} (h : Vps.Lawful d L) (i : Vps.Instrument) :
  i ∈ L → ∀ (c : Vps.Citation), c ∈ i.supersedes → ∃ t, t ∈ L ∧ t.cite = c
'Vps.supersession_grounded' depends on axioms: [propext, Quot.sound]
Vps.citation_unique {d : String} {L : List Vps.Instrument} (h : Vps.Lawful d L) (i : Vps.Instrument) :
  i ∈ L → ∀ (j : Vps.Instrument), j ∈ L → i.cite = j.cite → i = j
'Vps.citation_unique' depends on axioms: [propext, Quot.sound]
Vps.supersession_respects_rank {d : String} {L : List Vps.Instrument} (h : Vps.Lawful d L) (j : Vps.Instrument) :
  j ∈ L →
    ∀ (c : Vps.Citation), c ∈ j.supersedes → ∀ (t : Vps.Instrument), t ∈ L → t.cite = c → t.kind.rank ≤ j.kind.rank
'Vps.supersession_respects_rank' depends on axioms: [propext, Quot.sound]
Vps.entrenched_immune {d : String} {L : List Vps.Instrument} (h : Vps.Lawful d L) (e : Vps.Instrument) :
  e ∈ L → e.entrenched = true → ∀ (j : Vps.Instrument), j ∈ L → ¬e.cite ∈ j.supersedes
'Vps.entrenched_immune' depends on axioms: [propext, Quot.sound]
Vps.entrenched_effective {d : String} {L : List Vps.Instrument} (h : Vps.Lawful d L) (e : Vps.Instrument) :
  e ∈ L → e.entrenched = true → Vps.effectiveB L e = true
'Vps.entrenched_effective' depends on axioms: [propext, Quot.sound]
Vps.every_deny_names_its_law {L : List Vps.Instrument} {f : Vps.Facts} {cs : List Vps.Citation}
  (h : Vps.decideVerdict L f = Vps.Verdict.deny cs) : cs ≠ []
'Vps.every_deny_names_its_law' depends on axioms: [propext, Classical.choice, Quot.sound]
Vps.entrenched_bites {d : String} {L : List Vps.Instrument} {f : Vps.Facts} {e : Vps.Instrument} (h : Vps.Lawful d L)
  (he : e ∈ L) (hent : e.entrenched = true) (hv : Vps.violated f e = true) :
  ∃ cs, Vps.decideVerdict L f = Vps.Verdict.deny cs ∧ e.cite ∈ cs
'Vps.entrenched_bites' depends on axioms: [propext, Classical.choice, Quot.sound]
Vps.res_judicata {table : List Vps.Precedent} {oracle : String → Vps.Verdict} {q : String}
  (hs : Vps.Sound table oracle) : Vps.answer table oracle q = oracle q
'Vps.res_judicata' depends on axioms: [propext]
Vps.book_lawful : Vps.Lawful Vps.digest Vps.theBook
'Vps.book_lawful' does not depend on any axioms
```

These axiom reports describe the named theorem dependencies, not the entire
trusted base of the deployed system. None of these ten reports includes
`ofReduceBool`; that does not remove the compiler trust used by the separate
`native_decide` examples, nor verify the external fact extractor. This
measurement builds the imported library and elaborates the scratch file; it
is not an independent `leanchecker` replay or an end-to-end gate test.
