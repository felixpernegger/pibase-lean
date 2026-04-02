import PibaseLean.Properties.P65.Defs

namespace PiBase.Formal

abbrev P65 := CardEqContinuum

class NP65 (X : Type*) where
  not_p65 : ¬ P65 X

end PiBase.Formal
