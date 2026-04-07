import Mathlib.Data.Countable.Defs
import PiBaseLean.Properties.Bundled.Defs

namespace PiBase

/- 57. Countable -/
#check Countable

end PiBase

namespace PiBase.Formal

def P57 : Property where
  toPred X := Countable X
  well_defined φ _ := .of_equiv _ φ.toEquiv

end PiBase.Formal
