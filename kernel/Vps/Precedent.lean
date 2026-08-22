/-
Res judicata (Charter, Art. 7): precedent as a memo table over question
hashes. The same question is never litigated twice, and a sound table can
never disagree with the gate — `res_judicata` is a theorem, not a citator
audit.
-/
import Vps.Gate

namespace Vps

structure Precedent where
  /-- Hash of the normalised question. -/
  question : String
  verdict : Verdict
deriving DecidableEq, Repr

/-- A table is sound when every recorded answer is what the oracle
    (the gate, or a bench whose ruling was compiled into the book)
    would answer. -/
def Sound (table : List Precedent) (oracle : String → Verdict) : Prop :=
  ∀ p, p ∈ table → oracle p.question = p.verdict

/-- Answer from precedent when it exists; deliberate otherwise. -/
def answer (table : List Precedent) (oracle : String → Verdict) (q : String) : Verdict :=
  match table.find? (fun p => decide (p.question = q)) with
  | some p => p.verdict
  | none => oracle q

/-- **Art. 7, `res_judicata`.** A sound precedent table never changes an
    outcome: the fast path and the deliberated path agree, always. -/
theorem res_judicata {table : List Precedent} {oracle : String → Verdict} {q : String}
    (hs : Sound table oracle) : answer table oracle q = oracle q := by
  unfold answer
  cases hf : table.find? (fun p => decide (p.question = q)) with
  | none => rfl
  | some p =>
    have hmem : p ∈ table := List.mem_of_find?_eq_some hf
    have hq' := List.find?_some hf
    have hq : p.question = q := of_decide_eq_true hq'
    rw [← hq]
    exact (hs p hmem).symm

end Vps
