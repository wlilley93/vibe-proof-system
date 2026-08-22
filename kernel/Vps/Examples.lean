/-
Compile-time example vectors (Charter, Art. 8): every operative rule in
the book must demonstrate one world it denies and one it allows. A rule
that cannot produce both is unfalsifiable and does not belong in the book.
These are checked at every build; a rule change that flips them is
non-silent.
TRUST NOTE (Art. 8): these examples close with `native_decide` because the
proof kernel reduces `String.isPrefixOf` too slowly for plain `decide`.
`native_decide` trusts the Lean COMPILER (via the `ofReduceBool` axiom), a
wider base than the proof kernel alone. This is acceptable here — example
vectors are falsifiability witnesses, not the safety argument; every
theorem in Proofs.lean is compiler-independent — but it is named in the
Charter's trusted base, and Phase 1 retires it by moving path scopes to a
segment-typed representation the kernel can reduce.
-/
import Vps.Book

namespace Vps

-- [2026] VPS 2 (Kernel Protection): kernel edit without a record → deny
example :
    gate { pathsChanged := ["kernel/Vps/Gate.lean"], recordsAdded := 0 }
      = .deny [actKernelProtection.cite] := by native_decide

-- [2026] VPS 2: kernel edit carrying a record → allow
example :
    gate { pathsChanged := ["kernel/Vps/Gate.lean", "record/0005.md"], recordsAdded := 1 }
      = .allow := by native_decide

-- [2026] VPS 3 (Gate Integrity): touching the hook scripts → deny
example :
    gate { pathsChanged := ["gate/pre-commit"], recordsAdded := 1 }
      = .deny [actGateIntegrity.cite] := by native_decide

-- [2026] VPS 4 (Record Discipline): law prose edit with a record → allow
example :
    gate { pathsChanged := ["law/2026-vps-4.md", "record/0006.md"], recordsAdded := 1 }
      = .allow := by native_decide

-- Ordinary ungoverned work is free
example :
    gate { pathsChanged := ["src/app.ts"], recordsAdded := 0 }
      = .allow := by native_decide

end Vps
