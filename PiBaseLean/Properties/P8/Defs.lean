module

public import Mathlib.Topology.Separation.Regular
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

namespace PiBase

/- 8. T₅-Space -/
#check T5Space

end PiBase

namespace PiBase.Formal

def P8 : Property where
  toPred := T5Space
  well_defined φ _ := φ.t5Space

end PiBase.Formal
