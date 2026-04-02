import PibaseLean.Properties.P59.Defs

namespace PiBase.Formal

abbrev P59 := CardLessPowerContinuum

class NP59 (X : Type*) where
  not_p59 : ¬ P59 X

end PiBase.Formal
