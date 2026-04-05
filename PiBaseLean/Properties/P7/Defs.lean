import Mathlib.Topology.Separation.Regular
import PiBaseLean.Properties.Bundled.Defs

namespace PiBase

/- 7. T₄-Space -/
#check T4Space

end PiBase

namespace PiBase.Formal

def P7 : Property where
  toPred := T4Space
  well_defined' φ _ := φ.t4Space

end PiBase.Formal
