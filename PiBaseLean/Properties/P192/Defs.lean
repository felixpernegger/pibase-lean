module

public import Mathlib.Topology.Sober
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

namespace PiBase

/- 192. Quasi sober -/
#check QuasiSober

end PiBase

namespace PiBase.Formal

def P192 : Property where
  toPred := QuasiSober
  well_defined φ _ := φ.symm.isClosedEmbedding.quasiSober

end PiBase.Formal
