module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P16.Defs
public import PiBaseLean.Properties.P145.Defs

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

/-- Theorem T13: P16 (CompactSpace) => P145 (StronglyParacompactSpace) -/
instance instStronglyParacompactSpaceOfCompactSpace (X : Type u)
    [TopologicalSpace X] [h : CompactSpace X] : StronglyParacompactSpace X where
  starFinite_refinement α s so sc := by
    obtain ⟨t, ht⟩ := h.isCompact_univ.elim_finite_subcover s so (univ_subset_iff.mpr sc)
    refine ⟨t, fun r ↦ s r, by simp [so], ?_, ?_, ?_⟩
    · rw [← univ_subset_iff.mp ht]
      ext
      simp
    · apply Finite.starFinite
      infer_instance
    · exact fun b ↦ ⟨b, by simp⟩

end PiBase

namespace PiBase.Formal

theorem T13 : P16 ≤ P145 := fun X _ ↦ @instStronglyParacompactSpaceOfCompactSpace X _

end PiBase.Formal
