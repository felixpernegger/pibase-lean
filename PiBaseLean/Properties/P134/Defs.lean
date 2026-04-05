import Mathlib.Topology.Separation.Basic
import PiBaseLean.Properties.Bundled.Defs

namespace PiBase

/- 134. R₁ space -/
#check R1Space

end PiBase

namespace PiBase.Formal

def P134 : Property where
  toPred := R1Space
  well_defined' φ _ := φ.symm.isInducing.r1Space

end PiBase.Formal
