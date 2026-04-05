import Mathlib.Topology.Separation.Regular
import PiBaseLean.Properties.Bundled.Defs

namespace PiBase

/- 11. Regular -/
#check RegularSpace

end PiBase

namespace PiBase.Formal

def P11 : Property where
  toPred := RegularSpace
  well_defined' φ _ := φ.symm.isInducing.regularSpace

end PiBase.Formal
