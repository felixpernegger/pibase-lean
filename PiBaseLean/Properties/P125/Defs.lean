module

public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

namespace PiBase

/- 125. Has multiple points -/
#check Nontrivial

end PiBase

namespace PiBase.Formal

def P125 : Property where
  toPred X := Nontrivial X
  well_defined φ _ := φ.symm.toEquiv.nontrivial

end PiBase.Formal
