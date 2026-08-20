module

public import Mathlib.Topology.Order

@[expose] public section

namespace PiBase

/- 203. Almost discrete -/
class AlmostDiscreteSpace (X : Type*) [TopologicalSpace X] : Prop where
  ex_point : ∃ p : X, ∀ x : X, x ≠ p ↔ IsOpen {x}

end PiBase
