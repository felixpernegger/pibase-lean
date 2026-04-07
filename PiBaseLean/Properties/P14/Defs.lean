module

public import Mathlib.Topology.Separation.Regular
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

namespace PiBase

/- 14. Completely normal -/
#check CompletelyNormalSpace

end PiBase

namespace PiBase.Formal

def P14 : Property where
  toPred := CompletelyNormalSpace
  well_defined φ _ := φ.symm.isEmbedding.completelyNormalSpace

end PiBase.Formal
