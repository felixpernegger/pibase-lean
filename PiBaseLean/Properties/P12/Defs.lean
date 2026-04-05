import Mathlib.Topology.Separation.CompletelyRegular
import PiBaseLean.Properties.Bundled.Defs

namespace PiBase

/- 12. Completely regular -/
#check CompletelyRegularSpace

end PiBase

namespace PiBase.Formal

def P12 : Property where
  toPred := CompletelyRegularSpace
  well_defined' φ _ := φ.symm.isInducing.completelyRegularSpace

end PiBase.Formal
