import Mathlib.Topology.Separation.Basic
import PiBaseLean.Properties.Bundled.Defs

namespace PiBase

/- 1. T₀-Space -/
#check T0Space

end PiBase

namespace PiBase.Formal

def P1 : Property where
  toPred := T0Space
  well_defined' φ _ := φ.t0Space

end PiBase.Formal
