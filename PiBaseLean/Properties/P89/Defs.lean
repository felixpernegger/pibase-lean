module

public import Mathlib.Topology.ContinuousMap.Basic

@[expose] public section

namespace PiBase

/- 89. Fixed point property -/
class FixedPointSpace (X : Type*) [TopologicalSpace X] : Prop where
  fixed_point : ∀ f : C(X, X), ∃ x : X, Function.IsFixedPt f x

end PiBase
