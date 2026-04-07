module

public import Mathlib.Topology.Sequences
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

namespace PiBase

/- 80. Frechet Urysohn -/
#check FrechetUrysohnSpace

end PiBase

namespace PiBase.Formal

def P80 : Property where
  toPred := FrechetUrysohnSpace
  well_defined φ _ := φ.symm.isInducing.frechetUrysohnSpace

end PiBase.Formal
