import PibaseLean.UnstableProperties.P58.Defs

namespace PiBase.Formal

abbrev P58 := CardLtContinuum

class NP58 (X : Type*) [TopologicalSpace X] where
  not_p58 : ¬ P58 X

end PiBase.Formal
