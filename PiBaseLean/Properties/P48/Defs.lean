module

public import Mathlib.Topology.Connected.TotallyDisconnected
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

namespace PiBase

/- 48. Totally separated -/
#check TotallySeparatedSpace

end PiBase

namespace PiBase.Formal

def P48 : Property where
  toPred := TotallySeparatedSpace
  well_defined φ h := sorry

end PiBase.Formal
