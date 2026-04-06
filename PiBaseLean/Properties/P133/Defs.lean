import Mathlib.Topology.Order.Basic

namespace PiBase

/- 133. LOTS -/
class LOTS (X : Type*) [TopologicalSpace X] : Prop where
  from_linear_order : ∃ (_ : LinearOrder X), OrderTopology X

end PiBase
