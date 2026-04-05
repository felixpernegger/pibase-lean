import Mathlib.Topology.Metrizable.CompletelyMetrizable
import PiBaseLean.Properties.Bundled.Defs

open TopologicalSpace

namespace PiBase

/- 55. Completely metrizable -/
#check IsCompletelyMetrizableSpace

end PiBase

namespace PiBase.Formal

def P55 : Property where
  toPred := IsCompletelyMetrizableSpace
  well_defined' φ _ := φ.symm.isClosedEmbedding.IsCompletelyMetrizableSpace

end PiBase.Formal
