import Mathlib

open Topology Set Function

/- 38. Injectively path connected -/
class InjPathConnectedSpace (X : Type u) [TopologicalSpace X] : Prop where
  nonempty : Nonempty X
  joined : Pairwise fun x y : X ↦
    ∃ f : Icc (0 : ℝ) 1 → X, Continuous f ∧ Injective f ∧ f 0 = x ∧ f 1 = y
