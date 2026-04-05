import Mathlib.Topology.Order

universe u

namespace PiBase

/- 203. Almost discrete -/
class AlmostDiscreteSpace (X : Type u) [TopologicalSpace X] : Prop where
  ex_point : ∃ p : X, ∀ x : X, x ≠ p ↔ IsOpen {x}

end PiBase
