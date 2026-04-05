import Mathlib.Data.Finite.Defs
import PiBaseLean.Properties.Bundled.Defs

namespace PiBase

/- 78. Finite -/
#check Finite

end PiBase

namespace PiBase.Formal

def P78 : Property where
  toPred X := Finite X
  well_defined' φ _ := .of_equiv _ φ.toEquiv

end PiBase.Formal
