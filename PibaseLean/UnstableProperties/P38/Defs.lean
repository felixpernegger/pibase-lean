import Mathlib

open Topology Set Function

namespace UnstablePiBase

/- 38. Injectively path connected -/
class InjPathConnectedSpace (X : Type*) [TopologicalSpace X] : Prop where
  joined : Pairwise fun x y : X ↦
    ∃ f : Icc (0 : ℝ) 1 → X, Continuous f ∧ Injective f ∧ f 0 = x ∧ f 1 = y

end UnstablePiBase
