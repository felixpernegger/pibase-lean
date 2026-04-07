module

public import Mathlib.Data.Countable.Defs
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

namespace PiBase

/- 57. Countable -/
#check Countable

end PiBase

namespace PiBase.Formal

def P57 : Property where
  toPred X := Countable X
  well_defined φ _ := .of_equiv _ φ.toEquiv

end PiBase.Formal
