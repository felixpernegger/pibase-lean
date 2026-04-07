module

public import Mathlib.Topology.Homeomorph.Lemmas
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

namespace PiBase

/- 16. Compact -/
#check CompactSpace

end PiBase

namespace PiBase.Formal

def P16 : Property where
  toPred := CompactSpace
  well_defined φ _ := φ.compactSpace

end PiBase.Formal
