import Mathlib.Logic.IsEmpty.Defs
import PiBaseLean.Properties.Bundled.Defs

namespace PiBase

/- 137. Empty space -/
#check IsEmpty

end PiBase

namespace PiBase.Formal

def P137 : Property where
  toPred X := IsEmpty X
  well_defined' φ _ := φ.symm.toEquiv.isEmpty

end PiBase.Formal
