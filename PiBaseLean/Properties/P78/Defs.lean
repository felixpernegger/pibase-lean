import Mathlib.Data.Finite.Defs

namespace PiBase

/- 78. Finite -/
#check Finite

end PiBase

namespace PiBase.Formal

abbrev P78 := Finite

class NP78 (X : Type*) where
  not_p78 : ¬ P78 X

end PiBase.Formal
