module

public import Mathlib.Topology.Metrizable.CompletelyMetrizable
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

open TopologicalSpace

namespace PiBase

/- 55. Completely metrizable -/
#check IsCompletelyMetrizableSpace

end PiBase

namespace PiBase.Formal

def P55 : Property where
  toPred := IsCompletelyMetrizableSpace
  well_defined φ _ := φ.symm.isClosedEmbedding.IsCompletelyMetrizableSpace

end PiBase.Formal
