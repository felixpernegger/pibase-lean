import PiBaseLean.Properties.Bundled.Defs

namespace PiBase

/- 128. Has multiple points -/
#check Nontrivial

end PiBase

namespace PiBase.Formal

def P128 : Property where
  toPred X := Nontrivial X
  well_defined' φ _ := Equiv.nontrivial φ.symm

end PiBase.Formal
