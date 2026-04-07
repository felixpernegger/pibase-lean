module

public import Mathlib.Topology.Separation.Basic
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

namespace PiBase

/- 135. R₀ space -/
#check R0Space

end PiBase

namespace PiBase.Formal

def P135 : Property where
  toPred := R0Space
  well_defined φ _ := φ.symm.isInducing.r0Space

end PiBase.Formal
