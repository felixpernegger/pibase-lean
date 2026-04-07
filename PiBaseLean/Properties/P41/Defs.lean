import Mathlib.Topology.Connected.LocallyConnected
import PiBaseLean.Properties.Bundled.Defs

namespace PiBase

/- 41. Locally connected -/
#check LocallyConnectedSpace

end PiBase

namespace PiBase.Formal

def P41 : Property where
  toPred := LocallyConnectedSpace
  well_defined φ _ := φ.symm.isOpenEmbedding.locallyConnectedSpace

end PiBase.Formal
