module

public import Mathlib.Topology.Order
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

namespace PiBase

/- 52. Discrete -/
#check DiscreteTopology

end PiBase

namespace PiBase.Formal

def P52 : Property where
  toPred := DiscreteTopology
  well_defined φ _ := φ.symm.isEmbedding.discreteTopology

end PiBase.Formal
