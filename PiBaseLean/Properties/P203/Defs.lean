import Mathlib.Topology.Order
import PiBaseLean.Properties.Bundled.Defs

namespace PiBase

/- 203. Almost discrete -/
class AlmostDiscreteSpace (X : Type*) [TopologicalSpace X] : Prop where
  ex_point : ∃ p : X, ∀ x : X, x ≠ p ↔ IsOpen {x}

end PiBase

namespace PiBase.Formal

def P203 : Property where
  toPred := AlmostDiscreteSpace
  well_defined φ h := sorry

end PiBase.Formal
