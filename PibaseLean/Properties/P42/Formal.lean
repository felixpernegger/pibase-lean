import PibaseLean.Properties.P42.Defs

variable (X : Type*) [TopologicalSpace X]

namespace PiBase.Formal

abbrev P42 := LocallyPathConnectedSpace

class NP38 (X : Type*) [TopologicalSpace X] where
  not_p38 := ¬ P42 X

end PiBase.Formal
