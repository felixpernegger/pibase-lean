module

public import Mathlib.Topology.Separation.Regular
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

namespace PiBase

/- 11. Regular -/
#check RegularSpace

end PiBase

namespace PiBase.Formal

def P11 : Property where
  toPred := RegularSpace
  well_defined φ _ := φ.symm.isInducing.regularSpace

end PiBase.Formal
