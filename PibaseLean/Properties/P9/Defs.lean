import Mathlib

open Topology Set Function

namespace PiBase

/- 9. Functionally Hausdorff -/
class CompletelyT2Space (X : Type u) [TopologicalSpace X] : Prop where
  completelyT2 : Pairwise fun x y : X ↦ ∃ f : Icc (0 : ℝ) 1 → X, Continuous f ∧ f 0 = x ∧ f 1 = y

end PiBase
