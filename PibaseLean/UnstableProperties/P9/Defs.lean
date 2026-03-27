import Mathlib

open Topology Set Function

namespace UnstablePiBase

/- 9. Functionally Hausdorff -/
class CompletelyT2Space (X : Type*) [TopologicalSpace X] : Prop where
  completelyT2 : Pairwise fun x y : X ↦ ∃ f : X → ℝ, Continuous f ∧ f x = 0 ∧ f y = 1

end UnstablePiBase
