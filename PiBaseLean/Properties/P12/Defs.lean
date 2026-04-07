module

public import Mathlib.Topology.Separation.CompletelyRegular
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

namespace PiBase

/- 12. Completely regular -/
#check CompletelyRegularSpace

end PiBase

namespace PiBase.Formal

def P12 : Property where
  toPred := CompletelyRegularSpace
  well_defined φ _ := φ.symm.isInducing.completelyRegularSpace

end PiBase.Formal
