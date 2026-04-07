module

public import Mathlib.Topology.Separation.Regular
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

namespace PiBase

/- 4. T25-Space -/
#check T25Space

end PiBase

namespace PiBase.Formal

def P4 : Property where
  toPred := T25Space
  well_defined φ _ := φ.t25Space

end PiBase.Formal
