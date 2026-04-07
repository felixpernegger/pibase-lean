module

public import Mathlib.Topology.NoetherianSpace
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

open TopologicalSpace

namespace PiBase

/- 208. Noetherian -/
#check NoetherianSpace

end PiBase

namespace PiBase.Formal

def P208 : Property where
  toPred := NoetherianSpace
  well_defined φ _ := φ.symm.isInducing.noetherianSpace

end PiBase.Formal
