module

public import Mathlib.Data.Finite.Defs
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

namespace PiBase

/- 78. Finite -/
#check Finite

end PiBase

namespace PiBase.Formal

def P78 : Property where
  toPred X := Finite X
  well_defined φ _ := .of_equiv _ φ.toEquiv

end PiBase.Formal
