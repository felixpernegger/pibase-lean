import Mathlib.Topology.Order
import PiBaseLean.Properties.Bundled.Defs

namespace PiBase

/- 129. Indiscrete space -/
#check IndiscreteTopology

end PiBase

namespace PiBase.Formal

def P129 : Property where
  toPred := IndiscreteTopology
  well_defined' φ _ := φ.symm.isInducing.indiscreteTopology

end PiBase.Formal
