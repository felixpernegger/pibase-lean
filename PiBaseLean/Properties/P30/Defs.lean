module

public import Mathlib.Topology.Compactness.Paracompact
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

namespace PiBase

/- 30. Paracompact -/
#check ParacompactSpace

end PiBase

namespace PiBase.Formal

def P30 : Property where
  toPred := ParacompactSpace
  well_defined φ _ := φ.symm.isClosedEmbedding.paracompactSpace

end PiBase.Formal
