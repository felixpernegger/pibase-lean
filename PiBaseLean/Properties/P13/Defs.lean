module

public import Mathlib.Topology.Separation.Regular
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

namespace PiBase

/- 13. Normal -/
#check NormalSpace

end PiBase

namespace PiBase.Formal

def P13 : Property where
  toPred := NormalSpace
  well_defined φ _ := φ.normalSpace

end PiBase.Formal
