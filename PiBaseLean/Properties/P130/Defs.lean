module

public import Mathlib.Topology.Compactness.LocallyCompact
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

namespace PiBase

/- 130. Locally compact space -/
#check LocallyCompactSpace

end PiBase

namespace PiBase.Formal

def P130 : Property where
  toPred := LocallyCompactSpace
  well_defined φ _ := φ.symm.isClosedEmbedding.locallyCompactSpace

end PiBase.Formal
