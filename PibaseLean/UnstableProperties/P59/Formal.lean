import PibaseLean.UnstableProperties.P59.Defs

namespace PiBase.Formal

abbrev P59 := CardLessPowerContinuum

class NP59 (X : Type*) [TopologicalSpace X] where
  not_p59 : ¬ P59 X

end PiBase.Formal
