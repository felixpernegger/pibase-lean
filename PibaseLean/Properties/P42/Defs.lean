import Mathlib

open Topology Set Function

namespace PiBase

/- 42. Locally path connected -/
class LocallyPathConnectedSpace (X : Type u) [TopologicalSpace X] : Prop where
  joined : Pairwise fun x y : X ↦
    ∃ f : Icc (0 : ℝ) 1 → X, Continuous f ∧ f 0 = x ∧ f 1 = y

end PiBase
