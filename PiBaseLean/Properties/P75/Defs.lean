module

public import Mathlib.Topology.Spectral.Basic
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

namespace PiBase

/- 75. Spectral Space -/
#check SpectralSpace

end PiBase

namespace PiBase.Formal

def P75 : Property where
  toPred := SpectralSpace
  well_defined φ _ := @φ.symm.isOpenEmbedding.spectralSpace _ _ _ _ _ _ φ.compactSpace

end PiBase.Formal
