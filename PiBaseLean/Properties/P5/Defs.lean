import Mathlib.Topology.Separation.Regular
import PiBaseLean.Properties.Bundled.Defs

namespace PiBase

/- 5. T₃-Space -/
#check T3Space

end PiBase

namespace PiBase.Formal

def P5 : Property where
  toPred := T3Space
  well_defined' φ _ := φ.t3Space

end PiBase.Formal
