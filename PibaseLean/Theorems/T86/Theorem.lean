import Mathlib.Analysis.Normed.Order.Lattice
import Mathlib.Analysis.RCLike.Basic
import PibaseLean.Properties.P9.Defs

open Topology Set Function TopologicalSpace

namespace PiBase

/- Theorem 86, functionally hausdorff implies T25 -/
instance CompletelyT2Space.T25Space
    {X : Type*} [TopologicalSpace X] [h : CompletelyT2Space X] :
    T25Space X := by
  apply T25Space.mk
  intro _ _ h'
  obtain ⟨f, cf, hf⟩ := h.completelyT2 h'
  apply Filter.disjoint_iff.mpr
  refine ⟨f ⁻¹' (Ioo (-0.5 : ℝ) 0.5), ?_, ?_⟩
  · apply (Filter.mem_lift'_sets (monotone_closure X)).mpr
    refine ⟨f ⁻¹' Ioo (-0.25  : ℝ) 0.25, ?_, ?_⟩
    · apply ContinuousAt.preimage_mem_nhds (Continuous.continuousAt cf)
      exact Ioo_mem_nhds (by norm_num [hf.1]) (by norm_num [hf.1])
    apply subset_trans (Continuous.closure_preimage_subset cf (Ioo (-0.25  : ℝ) 0.25))
    apply preimage_mono
    rw [closure_Ioo (by norm_num)]
    exact Icc_subset_Ioo (by norm_num) (by norm_num)
  refine ⟨f ⁻¹' (Ioo (0.5 : ℝ) 1.5), ?_, Disjoint.symm (Disjoint.preimage f (by simp))⟩
  apply (Filter.mem_lift'_sets (monotone_closure X)).mpr
  refine ⟨f ⁻¹' Ioo 0.75 1.25, ?_, ?_⟩
  · apply ContinuousAt.preimage_mem_nhds <| Continuous.continuousAt cf
    exact Ioo_mem_nhds (by norm_num [hf.2]) (by norm_num [hf.2])
  apply subset_trans <| Continuous.closure_preimage_subset cf (Ioo (0.75 : ℝ) 1.25)
  apply preimage_mono
  rw [closure_Ioo (by norm_num)]
  exact Icc_subset_Ioo (by norm_num) (by norm_num)

end PiBase
