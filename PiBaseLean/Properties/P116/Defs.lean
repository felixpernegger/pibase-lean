import Mathlib.Topology.MetricSpace.Polish
import PiBaseLean.Properties.Bundled.Defs

namespace PiBase

/- 116. Polish space -/
#check PolishSpace

end PiBase

namespace PiBase.Formal

def P116 : Property where
  toPred X := PolishSpace X
  well_defined φ _ := φ.symm.isClosedEmbedding.polishSpace

end PiBase.Formal
