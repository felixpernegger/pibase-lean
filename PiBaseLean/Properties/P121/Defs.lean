module

public import Mathlib.Topology.Metrizable.Basic
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

open TopologicalSpace

namespace PiBase

/- 121. Pseudometrizable space -/
#check PseudoMetrizableSpace

end PiBase

namespace PiBase.Formal

def P121 : Property where
  toPred := PseudoMetrizableSpace
  well_defined φ _ := φ.symm.isInducing.pseudoMetrizableSpace

end PiBase.Formal
