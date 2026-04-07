module

public import Mathlib.Topology.Order
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

namespace PiBase

/- 129. Indiscrete space -/
#check IndiscreteTopology

end PiBase

namespace PiBase.Formal

def P129 : Property where
  toPred := IndiscreteTopology
  well_defined φ _ := φ.symm.isInducing.indiscreteTopology

end PiBase.Formal
