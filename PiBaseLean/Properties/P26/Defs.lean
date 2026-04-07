module

public import Mathlib.Topology.Bases
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

open TopologicalSpace

namespace PiBase

/- 26. Separable -/
#check SeparableSpace

end PiBase

namespace PiBase.Formal

def P26 : Property where
  toPred := SeparableSpace
  well_defined φ _ := φ.symm.isOpenEmbedding.separableSpace

end PiBase.Formal
