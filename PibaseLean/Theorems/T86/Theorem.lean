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
  obtain ⟨f, fh⟩ := h.completelyT2 xy
  refine Filter.disjoint_iff.mpr ?_
  use (f ⁻¹' (Ico (0 : ℝ) 0.5))


end PiBase
