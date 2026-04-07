module

public import Mathlib.Topology.Separation.GDelta
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

namespace PiBase

/- 15. Perfectly normal -/
#check PerfectlyNormalSpace

end PiBase

namespace PiBase.Formal

def P15 : Property where
  toPred := PerfectlyNormalSpace
  well_defined φ h := sorry

end PiBase.Formal
