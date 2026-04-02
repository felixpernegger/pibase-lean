import PibaseLean.Properties.P9.Defs

open Topology Set Function

namespace PiBase

/- Theorem 86, functionally hausdorff implies T25 -/
instance CompletelyT2Space.T25Space
    {X : Type*} [TopologicalSpace X] [h : CompletelyT2Space X] :
    T25Space X := by
  apply T25Space.mk
  intro x y xy
  obtain ⟨f, cf, hf⟩ := h.completelyT2 xy
  apply Filter.disjoint_iff.mpr
  use (f ⁻¹' (Ioo (-0.5 : ℝ) 0.5))
  constructor
  · apply (Filter.mem_lift'_sets (monotone_closure X)).mpr
    use f ⁻¹' Ioo (-0.25  : ℝ) 0.25
    constructor
    · apply ContinuousAt.preimage_mem_nhds (Continuous.continuousAt cf)
      refine Ioo_mem_nhds ?_ ?_ <;> norm_num [hf.1]
    apply subset_trans (Continuous.closure_preimage_subset cf (Ioo (-0.25  : ℝ) 0.25))
    apply preimage_mono
    rw [closure_Ioo (by norm_num)]
    apply Icc_subset_Ioo (by norm_num) (by norm_num)
  use (f ⁻¹' (Ioo (0.5 : ℝ) 1.5))
  constructor
  · apply (Filter.mem_lift'_sets (monotone_closure X)).mpr
    use f ⁻¹' Ioo 0.75 1.25
    constructor
    · refine ContinuousAt.preimage_mem_nhds (Continuous.continuousAt cf) ?_
      refine Ioo_mem_nhds ?_ ?_ <;> norm_num [hf.2]
    apply subset_trans (Continuous.closure_preimage_subset cf (Ioo (0.75 : ℝ) 1.25))
    apply preimage_mono
    rw [closure_Ioo (by norm_num)]
    exact Icc_subset_Ioo (by norm_num) (by norm_num)
  exact Disjoint.symm (Disjoint.preimage f (by simp))

end PiBase
