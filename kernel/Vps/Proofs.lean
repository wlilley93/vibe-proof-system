/-
The theorems that replace v2's locks, sweeps, ratchets, and audits.

Each theorem quantifies over EVERY lawful book, so nothing here needs
re-running, re-sweeping, or re-litigating as the book grows: the compiler
re-establishes the whole set on every build, and an independent checker
replays them in CI.
-/
import Vps.Gate

namespace Vps

/-- **Art. 4, `sovereign_floor`.** No self-made law: every instrument in a
    lawful book either carries the sovereign genesis digest, or derives
    its force from a strictly higher-ranked instrument in the same book. -/
theorem sovereign_floor {L : List Instrument} (h : Lawful L) :
    ∀ i, i ∈ L →
      i.authority = .sovereign genesisDigest ∨
      ∃ p j, i.authority = .derived p ∧ j ∈ L ∧ j.cite = p ∧ i.kind.rank < j.kind.rank := by
  induction h with
  | genesis =>
    intro i hi
    rw [List.mem_singleton] at hi
    subst hi
    exact Or.inl rfl
  | @enact L n hL hauth hfresh ih =>
    intro x hx
    rw [List.mem_cons] at hx
    cases hx with
    | inr hxL =>
      cases ih x hxL with
      | inl hs => exact Or.inl hs
      | inr hd =>
        obtain ⟨p, j, ha, hj, hc, hr⟩ := hd
        exact Or.inr ⟨p, j, ha, List.mem_cons_of_mem _ hj, hc, hr⟩
    | inl hxn =>
      subst hxn
      have hauth' := hauth
      unfold authorised at hauth'
      rw [Bool.and_eq_true] at hauth'
      obtain ⟨h1, _⟩ := hauth'
      cases ha : x.authority with
      | sovereign d =>
        rw [ha] at h1
        simp only [authorityResolves] at h1
        have hd := of_decide_eq_true h1
        subst hd
        exact Or.inl ha
      | derived p =>
        rw [ha] at h1
        simp only [authorityResolves] at h1
        rw [List.any_eq_true] at h1
        obtain ⟨j, hjL, hj⟩ := h1
        rw [Bool.and_eq_true] at hj
        obtain ⟨hc, hr⟩ := hj
        exact Or.inr ⟨p, j, ha, List.mem_cons_of_mem _ hjL,
          of_decide_eq_true hc, of_decide_eq_true hr⟩

/-- **Art. 5 (support).** Supersession never dangles: every supersession
    target in a lawful book exists in that book. -/
theorem supersession_grounded {L : List Instrument} (h : Lawful L) :
    ∀ i, i ∈ L → ∀ c, i.supersedes = some c → ∃ t, t ∈ L ∧ t.cite = c := by
  induction h with
  | genesis =>
    intro i hi c hc
    rw [List.mem_singleton] at hi
    subst hi
    simp [genesisInstrument] at hc
  | @enact L n hL hauth hfresh ih =>
    intro x hx c hc
    rw [List.mem_cons] at hx
    cases hx with
    | inr hxL =>
      obtain ⟨t, ht, htc⟩ := ih x hxL c hc
      exact ⟨t, List.mem_cons_of_mem _ ht, htc⟩
    | inl hxn =>
      subst hxn
      have hauth' := hauth
      unfold authorised at hauth'
      rw [Bool.and_eq_true] at hauth'
      obtain ⟨_, h2⟩ := hauth'
      rw [hc] at h2
      simp only [supersessionLawful] at h2
      rw [Bool.and_eq_true] at h2
      obtain ⟨hany, _⟩ := h2
      rw [List.any_eq_true] at hany
      obtain ⟨t, htL, htc⟩ := hany
      rw [Bool.and_eq_true] at htc
      exact ⟨t, List.mem_cons_of_mem _ htL, of_decide_eq_true htc.1⟩

/-- **Art. 5, `citation_unique`.** Citations are never reused: two
    instruments in a lawful book sharing a citation are the same
    instrument. In v2 this was a runtime collision check; here it is a
    property of every book that can exist. -/
theorem citation_unique {L : List Instrument} (h : Lawful L) :
    ∀ i, i ∈ L → ∀ j, j ∈ L → i.cite = j.cite → i = j := by
  induction h with
  | genesis =>
    intro i hi j hj _
    rw [List.mem_singleton] at hi
    rw [List.mem_singleton] at hj
    subst hi; subst hj; rfl
  | @enact L n hL hauth hfresh ih =>
    intro i hi j hj hc
    have hfresh' := hfresh
    unfold fresh at hfresh'
    rw [List.all_eq_true] at hfresh'
    rw [List.mem_cons] at hi
    rw [List.mem_cons] at hj
    cases hi with
    | inl hin =>
      subst hin
      cases hj with
      | inl hjn => rw [hjn]
      | inr hjL =>
        have hne := of_decide_eq_true (hfresh' j hjL)
        exact absurd hc.symm hne
    | inr hiL =>
      cases hj with
      | inl hjn =>
        subst hjn
        have hne := of_decide_eq_true (hfresh' i hiL)
        exact absurd hc hne
      | inr hjL => exact ih i hiL j hjL hc

/-- **Art. 5, `supersession_respects_rank`.** Law is amended only from
    equal or higher rank: in any lawful book, whatever an instrument
    supersedes is of equal or lower rank. A County ruling cannot repeal
    a statute. -/
theorem supersession_respects_rank {L : List Instrument} (h : Lawful L) :
    ∀ j, j ∈ L → ∀ c, j.supersedes = some c →
    ∀ t, t ∈ L → t.cite = c → t.kind.rank ≤ j.kind.rank := by
  induction h with
  | genesis =>
    intro j hj c hc
    rw [List.mem_singleton] at hj
    subst hj
    simp [genesisInstrument] at hc
  | @enact L n hL hauth hfresh ih =>
    intro j hj c hc t ht htc
    have hfresh' := hfresh
    unfold fresh at hfresh'
    rw [List.all_eq_true] at hfresh'
    rw [List.mem_cons] at hj
    rw [List.mem_cons] at ht
    cases hj with
    | inl hjn =>
      -- the superseder is the newly enacted instrument
      subst hjn
      have hauth' := hauth
      unfold authorised at hauth'
      rw [Bool.and_eq_true] at hauth'
      obtain ⟨_, h2⟩ := hauth'
      rw [hc] at h2
      simp only [supersessionLawful] at h2
      rw [Bool.and_eq_true] at h2
      obtain ⟨hany, _⟩ := h2
      rw [List.any_eq_true] at hany
      obtain ⟨w, hwL, hw⟩ := hany
      rw [Bool.and_eq_true] at hw
      have hwc : w.cite = c := of_decide_eq_true hw.1
      have hwr := of_decide_eq_true hw.2
      cases ht with
      | inl htn =>
        -- t is the new instrument itself: its citation would collide with
        -- the witness already bearing c, contradicting freshness
        subst htn
        have hne := of_decide_eq_true (hfresh' w hwL)
        exact absurd (hwc.trans htc.symm) hne
      | inr htL =>
        -- citation uniqueness on the grown book identifies t with the witness
        have hlaw : Lawful (j :: L) := Lawful.enact hL hauth hfresh
        have hte : t = w :=
          citation_unique hlaw t (List.mem_cons_of_mem _ htL) w
            (List.mem_cons_of_mem _ hwL) (htc.trans hwc.symm)
        rw [hte]
        exact hwr
    | inr hjL =>
      cases ht with
      | inl htn =>
        -- t is the new instrument: an old target bearing c already exists
        -- in L, contradicting the new citation's freshness
        subst htn
        obtain ⟨w, hwL, hwc⟩ := supersession_grounded hL j hjL c hc
        have hne := of_decide_eq_true (hfresh' w hwL)
        exact absurd (hwc.trans htc.symm) hne
      | inr htL => exact ih j hjL c hc t htL htc

/-- **Art. 5, `entrenched_immune`.** No instrument in any lawful book
    supersedes an entrenched instrument's citation. In v2 this took an
    entrenchment clause, a raw-byte invariant, and a digest-pinned lock;
    here it is a consequence of the only door law can enter through. -/
theorem entrenched_immune {L : List Instrument} (h : Lawful L) :
    ∀ e, e ∈ L → e.entrenched = true →
    ∀ j, j ∈ L → j.supersedes ≠ some e.cite := by
  induction h with
  | genesis =>
    intro e he _ j hj
    rw [List.mem_singleton] at he
    rw [List.mem_singleton] at hj
    subst he; subst hj
    simp [genesisInstrument]
  | @enact L n hL hauth hfresh ih =>
    intro e he hent j hj hsup
    have hfresh' := hfresh
    unfold fresh at hfresh'
    rw [List.all_eq_true] at hfresh'
    have hauth' := hauth
    unfold authorised at hauth'
    rw [Bool.and_eq_true] at hauth'
    obtain ⟨_, h2⟩ := hauth'
    rw [List.mem_cons] at he
    rw [List.mem_cons] at hj
    cases hj with
    | inl hjn =>
      -- the offender is the newly enacted instrument
      subst hjn
      rw [hsup] at h2
      simp only [supersessionLawful] at h2
      rw [Bool.and_eq_true] at h2
      obtain ⟨hany, hall⟩ := h2
      cases he with
      | inl hen =>
        -- it would supersede its own fresh citation: the target must
        -- already exist in L, contradicting freshness
        subst hen
        rw [List.any_eq_true] at hany
        obtain ⟨t, htL, htc⟩ := hany
        rw [Bool.and_eq_true] at htc
        have hne := of_decide_eq_true (hfresh' t htL)
        exact hne (of_decide_eq_true htc.1)
      | inr heL =>
        -- it would supersede an entrenched instrument already in L,
        -- which `supersessionLawful` forbids
        rw [List.all_eq_true] at hall
        have hthis := hall e heL
        simp [hent] at hthis
    | inr hjL =>
      cases he with
      | inl hen =>
        -- an old instrument superseding the new fresh citation: its
        -- target existed at its own enactment, contradicting freshness
        subst hen
        obtain ⟨t, htL, htc⟩ := supersession_grounded hL j hjL e.cite hsup
        have hne := of_decide_eq_true (hfresh' t htL)
        exact hne htc
      | inr heL => exact ih e heL hent j hjL hsup

/-- **Art. 5, `entrenched_effective`.** Entrenched law is always in force:
    it survives every possible future of the book. -/
theorem entrenched_effective {L : List Instrument} (h : Lawful L) :
    ∀ e, e ∈ L → e.entrenched = true → effectiveB L e = true := by
  intro e he hent
  unfold effectiveB
  rw [List.all_eq_true]
  intro j hj
  exact decide_eq_true (entrenched_immune h e he hent j hj)

/-- **Art. 2 (teeth), `every_deny_names_its_law`.** The gate never denies
    without citing at least one instrument. "Every denial names its
    instrument" was v2's best idea; here it is a theorem. -/
theorem every_deny_names_its_law {L : List Instrument} {f : Facts} {cs : List Citation}
    (h : decideVerdict L f = .deny cs) : cs ≠ [] := by
  unfold decideVerdict at h
  split at h
  · exact Verdict.noConfusion h
  · injection h with hcs
    rw [← hcs]
    simp

/-- **Art. 5, `entrenched_bites`.** In any lawful book, an entrenched
    instrument that a change violates produces a denial citing it. No
    lawful growth of the book can ever silence entrenched law. -/
theorem entrenched_bites {L : List Instrument} {f : Facts} {e : Instrument}
    (h : Lawful L) (he : e ∈ L) (hent : e.entrenched = true)
    (hv : violated f e = true) :
    ∃ cs, decideVerdict L f = .deny cs ∧ e.cite ∈ cs := by
  have heff := entrenched_effective h e he hent
  have hp : (effectiveB L e && violated f e) = true := by
    rw [Bool.and_eq_true]
    exact ⟨heff, hv⟩
  have hmem : e ∈ L.filter (fun i => effectiveB L i && violated f i) :=
    List.mem_filter.mpr ⟨he, hp⟩
  cases hf : L.filter (fun i => effectiveB L i && violated f i) with
  | nil =>
    rw [hf] at hmem
    simp at hmem
  | cons v vs =>
    refine ⟨(v :: vs).map (·.cite), ?_, ?_⟩
    · unfold decideVerdict
      rw [hf]
    · rw [hf] at hmem
      exact List.mem_map.mpr ⟨e, hmem, rfl⟩

end Vps
