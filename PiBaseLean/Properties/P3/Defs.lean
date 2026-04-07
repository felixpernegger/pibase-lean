import Mathlib.Topology.Separation.Hausdorff
import PiBaseLean.Properties.Bundled.Defs

namespace PiBase

/- 3. T2-Space -/
#check T2Space

end PiBase

namespace PiBase.Formal

def P3 : Property where
  toPred := T2Space
  well_defined φ _ := φ.t2Space

end PiBase.Formal
