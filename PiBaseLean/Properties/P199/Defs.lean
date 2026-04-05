import Mathlib.Topology.Homotopy.Contractible
import PiBaseLean.Properties.Bundled.Defs

namespace PiBase

/- 199. Contractible -/
#check ContractibleSpace

end PiBase

namespace PiBase.Formal

def P199 : Property where
  toPred := ContractibleSpace
  well_defined' φ _ := φ.contractibleSpace

end PiBase.Formal
