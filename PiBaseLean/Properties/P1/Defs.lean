module

public import Mathlib.Topology.Separation.Basic
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

namespace PiBase

/- 1. T₀-Space -/
#check T0Space

end PiBase

namespace PiBase.Formal

def P1 : Property where
  toPred := T0Space
  well_defined φ _ := φ.t0Space

end PiBase.Formal
