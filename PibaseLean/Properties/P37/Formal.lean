import PibaseLean.Properties.P37.Defs

variable (X : Type*) [TopologicalSpace X]

namespace PiBase.Formal

abbrev P37 := PrePathConnectedSpace

class NP37 (X : Type*) [TopologicalSpace X] where
  not_p37 := ¬ P37 X

end PiBase.Formal
