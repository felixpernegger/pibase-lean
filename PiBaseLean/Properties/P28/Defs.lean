import Mathlib.Topology.Bases
import PiBaseLean.Properties.Bundled.Defs

namespace PiBase

/- 28. Second countable -/
#check FirstCountableTopology

end PiBase

namespace PiBase.Formal

def P28 : Property where
  toPred := FirstCountableTopology
  well_defined φ _ := φ.symm.isInducing.firstCountableTopology

end PiBase.Formal
