module

public import Mathlib.Topology.Homotopy.Contractible
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

namespace PiBase

/- 199. Contractible -/
#check ContractibleSpace

end PiBase

namespace PiBase.Formal

def P199 : Property where
  toPred := ContractibleSpace
  well_defined φ _ := φ.symm.contractibleSpace

end PiBase.Formal
