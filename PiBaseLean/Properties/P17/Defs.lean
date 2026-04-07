module

public import Mathlib.Topology.Compactness.SigmaCompact
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

namespace PiBase

/- 17. σ-compact -/
#check SigmaCompactSpace

end PiBase

namespace PiBase.Formal

def P17 : Property where
  toPred := SigmaCompactSpace
  well_defined φ _ := φ.symm.isClosedEmbedding.sigmaCompactSpace

end PiBase.Formal
