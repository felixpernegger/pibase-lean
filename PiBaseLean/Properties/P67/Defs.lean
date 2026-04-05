import Mathlib.Topology.Separation.GDelta
import PiBaseLean.Properties.Bundled.Defs

namespace PiBase

/- 67. T6 -/
#check T6Space

end PiBase

namespace PiBase.Formal

def P67 : Property where
  toPred := T6Space
  well_defined' φ h := sorry

end PiBase.Formal
