import Mathlib.Topology.NoetherianSpace
import PiBaseLean.Properties.Bundled.Defs

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
