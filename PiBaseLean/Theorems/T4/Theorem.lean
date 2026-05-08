module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P19.Defs
public import PiBaseLean.Properties.P22.Defs
public import Mathlib

@[expose] public section

open Topology Set Function TopologicalSpace

namespace PiBase

/- Theorem 4, countably compact implies pseudocompact -/
instance instPseudocompactSpaceOfCountablyCompactSpace
    {X : Type*} [TopologicalSpace X] [h : CountablyCompactSpace X] :
    PseudocompactSpace X where
  pseudocompact f hf := by
    /- have countableOpenCover := isCountablyCompact_iff_countable_open_cover.mp  -/
    let S (n : ℕ) : Set ℝ := Set.Ioo (-n : ℝ) (n : ℝ)
    let preimS (n : ℕ) : Set X := Set.preimage f (S n)
    let Sn_open (n : ℕ) : IsOpen (S n) := by
      unfold S
      exact isOpen_Ioo
    let preim_open (n : ℕ) : IsOpen (preimS n) :=
      (continuous_def.mp hf) (S n) (Sn_open n)

    have S_union_eq_R : (Set.univ : Set ℝ) = (⋃ (i : ℕ), S i) := by
      ext x
      constructor
      · simp only [mem_univ, mem_iUnion, forall_const]
        use ⌈|x|⌉₊ + 1
        unfold S
        simp only [Set.mem_Ioo]

        -- AI stuff
        have h1 : |x| < ↑(⌈|x|⌉₊ + 1) := by
          calc |x| ≤ ↑⌈|x|⌉₊ := Nat.le_ceil |x|
          _ < ↑(⌈|x|⌉₊ + 1) := by norm_num
        constructor
        · -- goal: -↑(⌈|x|⌉₊ + 1) < x
          linarith [neg_abs_le x]
        · -- goal: x < ↑(⌈|x|⌉₊ + 1)
          linarith [le_abs_self x]
        -- AI stuff ends

      · simp
    
    let h_cover : (Set.univ : Set X) ⊆ ⋃ (i : ℕ), preimS i := by
      intro x hx
      clear hx
      unfold preimS
      rw [← Set.preimage_iUnion, Set.mem_preimage]
      simp [← S_union_eq_R]

    have X_IsCountablyCompact : IsCountablyCompact (Set.univ : Set X) := CountablyCompactSpace.isCountablyCompact_univ
    have finite_subcover_ofX := isCountablyCompact_iff_countable_open_cover.mp
      X_IsCountablyCompact preimS preim_open h_cover
    obtain ⟨t, ht⟩ := finite_subcover_ofX

    let St_union := ⋃ i ∈ t, S i
    have St_union_subset_range: range f ⊆ St_union := by 
      rw [Set.range_subset_iff]
      intro x
      unfold St_union
      have hx := ht (Set.mem_univ x)

      /- rw [Finset.mem_biUnion] at hx -/

      simp only [mem_iUnion, exists_prop] at hx ⊢
      unfold preimS at hx
      obtain ⟨i, hi1, hi2⟩ := hx
      use i
      simpa [hi1]

    constructor
    · apply BddBelow.mono St_union_subset_range
      unfold St_union
      conv =>
        right
        right
        intro i
        rw [← Finset.mem_coe]
      rw [Set.Finite.bddBelow_biUnion t.finite_toSet]
      simp [S]

    · apply BddAbove.mono St_union_subset_range
      unfold St_union
      conv =>
        right
        right
        intro i
        rw [← Finset.mem_coe]

      rw [Set.Finite.bddAbove_biUnion t.finite_toSet]
      simp [S]

end PiBase

namespace PiBase.Formal

theorem T4 : P19 ≤ P22 := @instPseudocompactSpaceOfCountablyCompactSpace

end PiBase.Formal
