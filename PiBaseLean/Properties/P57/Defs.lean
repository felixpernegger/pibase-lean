import Mathlib.Data.Countable.Defs

namespace PiBase

/- 57. Countable -/
#check Countable

end PiBase

namespace PiBase.Formal

abbrev P57 := Countable

class NP57 (X : Type*) where
  not_p57 : ¬ P57 X

end PiBase.Formal
