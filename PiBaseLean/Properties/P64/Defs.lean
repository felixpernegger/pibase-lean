module

public import Mathlib.Topology.Homeomorph.Lemmas
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

namespace PiBase

/- 64. Baire -/
#check BaireSpace

end PiBase

namespace PiBase.Formal

def P64 : Property where
  toPred := BaireSpace
  well_defined φ _ := φ.baireSpace

end PiBase.Formal
