import PibaseLean.Properties.P37.Defs

variable (X : Type*) [TopologicalSpace X]

namespace PiBase.Formal

abbrev P42 := PrePathConnectedSpace

class NP38 (X : Type*) [TopologicalSpace X] where
  not_p38 := ¬ P42 X

end PiBase.Formal
