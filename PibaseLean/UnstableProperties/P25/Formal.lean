import PibaseLean.UnstableProperties.P25.Defs

variable (X : Type*) [TopologicalSpace X]

namespace PiBase.Formal

abbrev P25 := ExhaustibleByCompacts

class NP25 (X : Type*) [TopologicalSpace X] where
  not_p25 : ¬ P25 X

end PiBase.Formal
