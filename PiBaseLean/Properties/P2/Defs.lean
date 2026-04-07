import Mathlib.Topology.Separation.Basic
import PiBaseLean.Properties.Bundled.Defs

namespace PiBase

/- 1. T₁-Space -/
#check T1Space

end PiBase

namespace PiBase.Formal

def P2 : Property where
  toPred := T1Space
  well_defined φ _ := φ.t1Space

end PiBase.Formal
