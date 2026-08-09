module

public import Mathlib.Topology.Connected.LocallyPathConnected
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

namespace PiBase

/- 42. Locally path-connected -/
#check LocallyPathConnectedSpace

end PiBase

namespace PiBase.Formal

def P42 : Property where
  toPred := LocallyPathConnectedSpace
  well_defined φ _ := φ.symm.isOpenEmbedding.locallyPathConnectedSpace

end PiBase.Formal
