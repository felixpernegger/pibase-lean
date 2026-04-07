module

public import Mathlib.Topology.Separation.CompletelyRegular
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

namespace PiBase

/- 6. T35-Space -/
#check T35Space

end PiBase

namespace PiBase.Formal

def P6 : Property where
  toPred := T35Space
  well_defined φ _ := φ.symm.isEmbedding.t35Space

end PiBase.Formal
