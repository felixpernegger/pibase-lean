module

public import Mathlib.Topology.Order.Basic
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

namespace PiBase

/- 133. Lots -/
class Lots (X : Type*) [TopologicalSpace X] : Prop where
  from_linear_order : ∃ (_ : LinearOrder X), OrderTopology X

end PiBase

namespace PiBase.Formal

def P133 : Property where
  toPred := Lots
  well_defined φ h := sorry

end PiBase.Formal
