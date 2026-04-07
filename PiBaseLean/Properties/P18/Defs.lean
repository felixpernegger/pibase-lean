module

public import Mathlib.Topology.Compactness.Lindelof
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

namespace PiBase

/- 18. Lindelöf -/
#check LindelofSpace

end PiBase

namespace PiBase.Formal

def P18 : Property where
  toPred := LindelofSpace
  well_defined φ _ := φ.symm.isClosedEmbedding.LindelofSpace

end PiBase.Formal
