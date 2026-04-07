module

public import Mathlib.Topology.Connected.LocPathConnected
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

namespace PiBase

/- 42. Locally path-connected -/
#check LocPathConnectedSpace

end PiBase

namespace PiBase.Formal

def P42 : Property where
  toPred := LocPathConnectedSpace
  well_defined φ _ := φ.symm.isOpenEmbedding.locPathConnectedSpace

end PiBase.Formal
