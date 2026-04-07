module

public import Mathlib.Topology.Bases
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

namespace PiBase

/- 28. Second countable -/
#check FirstCountableTopology

end PiBase

namespace PiBase.Formal

def P28 : Property where
  toPred := FirstCountableTopology
  well_defined φ _ := φ.symm.isInducing.firstCountableTopology

end PiBase.Formal
