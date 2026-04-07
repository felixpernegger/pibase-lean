import Mathlib.Topology.Order
import PiBaseLean.Properties.Bundled.Defs

namespace PiBase

/- 52. Discrete -/
#check DiscreteTopology

end PiBase

namespace PiBase.Formal

def P52 : Property where
  toPred := DiscreteTopology
  well_defined φ _ := φ.symm.isEmbedding.discreteTopology

end PiBase.Formal
