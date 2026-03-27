import Mathlib

open Topology Set Function

namespace PiBase

/-- 42. Path connected
Note: Unlike Mathlib, we allow the space to be empty. -/
class PrePathConnectedSpace (X : Type u) [TopologicalSpace X] : Prop where
  joined : Pairwise fun x y : X ↦
    ∃ f : Icc (0 : ℝ) 1 → X, Continuous f ∧ f 0 = x ∧ f 1 = y

end PiBase
