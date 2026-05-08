module

public import Mathlib.Analysis.Normed.Order.Lattice
public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P19.Defs
public import PiBaseLean.Properties.P22.Defs

@[expose] public section

open Topology Set Function TopologicalSpace

namespace PiBase

/- Theorem T4: P19 (CountablyCompactSpace) => P22 (PseudocompactSpace) -/
theorem instPseudocompactSpaceOfCountablyCompactSpace
    {X : Type*} [TopologicalSpace X] [hX : CountablyCompactSpace X] :
    PseudocompactSpace X where
  pseudocompact f hf := by
    let S (n : ℕ) := Set.Ioo (-n : ℝ) n
    have preims_open n : IsOpen (f⁻¹' S n) := by
      simp [S, hf, isOpen_Ioo, continuous_def.mp]
    have S_union_eq_R : univ = ⋃ i, S i := by
      ext x
      simp only [mem_univ, mem_iUnion, mem_Ioo, true_iff, S]
      have ⟨y, hy⟩ := exists_nat_gt |x|
      exact ⟨y, abs_lt.mp hy⟩
    have preims_cover_X : univ ⊆ ⋃ i, f⁻¹' S i := by
      simp [← Set.preimage_iUnion, ← S_union_eq_R]
    have ⟨t, ht⟩ := isCountablyCompact_iff_countable_open_cover.mp
      hX.isCountablyCompact_univ _ preims_open preims_cover_X
    have hRange: range f ⊆ ⋃ i ∈ t, S i := by 
      simpa [← preimage_iUnion] using ht
    simp [BddBelow.mono hRange, BddAbove.mono hRange,
      ← Finset.set_biUnion_coe, S,
      t.finite_toSet.bddBelow_biUnion , t.finite_toSet.bddAbove_biUnion]

end PiBase

namespace PiBase.Formal

theorem T4 : P19 ≤ P22 := @instPseudocompactSpaceOfCountablyCompactSpace

end PiBase.Formal
