import Mathlib.Topology.Compactness.Paracompact
import PiBaseLean.Properties.Bundled.Defs

namespace PiBase

/- 30. Paracompact -/
#check ParacompactSpace

end PiBase

namespace PiBase.Formal

def P30 : Property where
  toPred := ParacompactSpace
  well_defined φ _ := φ.symm.isClosedEmbedding.paracompactSpace

end PiBase.Formal
