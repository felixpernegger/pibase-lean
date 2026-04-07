import Mathlib.Topology.Separation.Regular
import PiBaseLean.Properties.Bundled.Defs

namespace PiBase

/- 13. Normal -/
#check NormalSpace

end PiBase

namespace PiBase.Formal

def P13 : Property where
  toPred := NormalSpace
  well_defined φ _ := φ.normalSpace

end PiBase.Formal
