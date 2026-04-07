import Mathlib.Topology.Order.Basic
import PiBaseLean.Properties.Bundled.Defs

namespace PiBase

/- 133. LOTS -/
class LOTS (X : Type*) [TopologicalSpace X] : Prop where
  from_linear_order : ∃ (_ : LinearOrder X), OrderTopology X

end PiBase

namespace PiBase.Formal

def P133 : Property where
  toPred := LOTS
  well_defined φ h := sorry

end PiBase.Formal
