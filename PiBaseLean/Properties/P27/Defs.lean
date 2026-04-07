module

public import Mathlib.Topology.Homeomorph.Lemmas
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

namespace PiBase

/- 27. Second countable -/
#check SecondCountableTopology

end PiBase

namespace PiBase.Formal

def P27 : Property where
  toPred := SecondCountableTopology
  well_defined φ _ := φ.symm.secondCountableTopology

end PiBase.Formal
