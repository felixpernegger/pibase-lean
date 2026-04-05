import Mathlib.Topology.Connected.TotallyDisconnected
import PiBaseLean.Properties.Bundled.Defs

namespace PiBase

/- 48. Totally separated -/
#check TotallySeparatedSpace

end PiBase

namespace PiBase.Formal

def P48 : Property where
  toPred := TotallySeparatedSpace
  well_defined' φ h := sorry

end PiBase.Formal
