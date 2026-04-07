module

public import Mathlib.Topology.Compactness.LocallyCompact
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

namespace PiBase

/- 23. Weakly locally compact -/
#check WeaklyLocallyCompactSpace

end PiBase

namespace PiBase.Formal

def P23 : Property where
  toPred := WeaklyLocallyCompactSpace
  well_defined φ _ := φ.symm.isClosedEmbedding.weaklyLocallyCompactSpace

end PiBase.Formal
