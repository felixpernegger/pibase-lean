import Mathlib.Topology.Homeomorph.Lemmas
import PiBaseLean.Properties.Bundled.Defs

namespace PiBase

/- 16. Compact -/
#check CompactSpace

end PiBase

namespace PiBase.Formal

def P16 : Property where
  toPred := CompactSpace
  well_defined φ _ := φ.compactSpace

end PiBase.Formal
