import Mathlib.Analysis.Normed.Order.Lattice
import Mathlib.Analysis.RCLike.Basic
import PiBaseLean.Properties.Bundled.Basic
import PiBaseLean.Properties.P4.Defs
import PiBaseLean.Properties.P9.Defs

open Topology Set Function TopologicalSpace unitInterval

namespace PiBase

/- Theorem 86, functionally hausdorff implies T25 -/
instance instFunctionallyT2SpaceOfT25Space
    {X : Type*} [TopologicalSpace X] [h : FunctionallyT2Space X] :
    T25Space X := by
  refine ⟨fun _ _ h' ↦ ?_⟩
  obtain ⟨f, hf⟩ := h.functionally_t2 h'
  obtain ⟨b, b₀, b₁⟩ := exists_between (α := I) zero_lt_one
  obtain ⟨a, a₀, ab⟩ := exists_between b₀
  obtain ⟨c, bc, c₁⟩ := exists_between b₁
  refine Filter.disjoint_iff.mpr ⟨f ⁻¹' Iio b, ?_, f ⁻¹' Ioi b, ?_, Disjoint.preimage f ?_⟩
  · refine (Filter.mem_lift'_sets (monotone_closure X)).mpr ⟨f ⁻¹' Iio a, ?_, ?_⟩
    · exact f.continuousAt _ (Iio_mem_nhds (hf.1.trans_lt a₀))
    · refine subset_trans (f.continuous.closure_preimage_subset (Iio a)) <| preimage_mono ?_
      rw [closure_Iio' (a := a) ⟨0, a₀⟩]
      simpa only [Iic_subset_Iio]
  · refine (Filter.mem_lift'_sets (monotone_closure X)).mpr ⟨f ⁻¹' Ioi c, ?_, ?_⟩
    · exact f.continuousAt _ (Ioi_mem_nhds (c₁.trans_eq hf.2.symm))
    · refine subset_trans (f.continuous.closure_preimage_subset (Ioi c)) <| preimage_mono ?_
      rw [closure_Ioi' (a := c) ⟨1, c₁⟩]
      simpa only [Ici_subset_Ioi]
  · simp

end PiBase

namespace PiBase.Formal

theorem T86 : P9 ≤ P4 := @instFunctionallyT2SpaceOfT25Space

end PiBase.Formal
