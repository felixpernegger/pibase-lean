import Mathlib.Topology.Compactness.Lindelof
import PiBaseLean.Properties.Bundled.Defs

namespace PiBase

/- 18. Lindelöf -/
#check LindelofSpace

end PiBase

namespace PiBase.Formal

def P18 : Property where
  toPred := LindelofSpace
  well_defined' φ _ := φ.isClosedEmbedding.LindelofSpace

end PiBase.Formal
