import Mathlib
import PibaseLean.Properties.P9.Formal
import PibaseLean.Properties.P4.Formal

open Topology Set Function

namespace PiBase

/- Theorem 86, functionally hausdorff implies T25 -/
instance CompletelyT2Space.T25Space
    (X : Type u) [TopologicalSpace X] [h : CompletelyT2Space X] :
    T25Space X := by
  apply T25Space.mk
  intro x y xy
  obtain ⟨f, cf, hf⟩ := h.completelyT2 xy
  refine Filter.disjoint_iff.mpr ?_
  use (f ⁻¹' (Ioo (-0.5 : ℝ) 0.5))
  constructor
  · refine (Filter.mem_lift'_sets ?_).mpr ?_
    · exact monotone_closure X
    use f ⁻¹' Ioo (-0.25  : ℝ) 0.25
    constructor
    · refine ContinuousAt.preimage_mem_nhds ?_ ?_
      · exact Continuous.continuousAt cf
      · refine Ioo_mem_nhds ?_ ?_ <;> norm_num [hf.1]
    apply subset_trans (Continuous.closure_preimage_subset cf (Ioo (-0.25  : ℝ) 0.25))
    apply preimage_mono
    rw [closure_Ioo (by norm_num)]
    apply Icc_subset_Ioo (by norm_num) (by norm_num)
  use (f ⁻¹' (Ioo (0.5 : ℝ) 1.5))
  constructor
  · refine (Filter.mem_lift'_sets ?_).mpr ?_
    · exact monotone_closure X
    use f ⁻¹' Ioo 0.75 1.25
    constructor
    · refine ContinuousAt.preimage_mem_nhds ?_ ?_
      · exact Continuous.continuousAt cf
      · refine Ioo_mem_nhds ?_ ?_ <;> norm_num [hf.2]
    apply subset_trans (Continuous.closure_preimage_subset cf (Ioo (0.75 : ℝ) 1.25))
    apply preimage_mono
    rw [closure_Ioo (by norm_num)]
    apply Icc_subset_Ioo (by norm_num) (by norm_num)
  refine Disjoint.symm (Disjoint.preimage f ?_)
  simp

end PiBase
