import Mathlib.Topology.Compactness.LocallyCompact
import PiBaseLean.Properties.Bundled.Defs

namespace PiBase

/- 130. Locally compact space -/
#check LocallyCompactSpace

end PiBase

namespace PiBase.Formal

def P130 : Property where
  toPred := LocallyCompactSpace
  well_defined φ _ := φ.symm.isClosedEmbedding.locallyCompactSpace

end PiBase.Formal
