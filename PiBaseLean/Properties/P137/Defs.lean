module

public import Mathlib.Logic.IsEmpty.Defs
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

namespace PiBase

/- 137. Empty space -/
#check IsEmpty

end PiBase

namespace PiBase.Formal

def P137 : Property where
  toPred X := IsEmpty X
  well_defined φ _ := φ.symm.toEquiv.isEmpty

end PiBase.Formal
