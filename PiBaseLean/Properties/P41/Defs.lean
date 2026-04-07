module

public import Mathlib.Topology.Connected.LocallyConnected
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

namespace PiBase

/- 41. Locally connected -/
#check LocallyConnectedSpace

end PiBase

namespace PiBase.Formal

def P41 : Property where
  toPred := LocallyConnectedSpace
  well_defined φ _ := φ.symm.isOpenEmbedding.locallyConnectedSpace

end PiBase.Formal
