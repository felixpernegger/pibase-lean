import PibaseLean.Properties.P78.Defs

namespace PiBase.Formal

abbrev P78 := Finite

class NP78 (X : Type*) where
  not_p78 : ¬ P78 X

end PiBase.Formal
