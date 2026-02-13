import PibaseLean.Properties.P22.Defs

variable (X : Type*) [TopologicalSpace X]

namespace PiBase.Formal

abbrev P22 := Pseudocompact

class NP22 (X : Type*) [TopologicalSpace X] where
  not_p22 : ¬ P22 X

end PiBase.Formal
