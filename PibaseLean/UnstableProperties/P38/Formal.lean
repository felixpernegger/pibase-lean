import PibaseLean.UnstableProperties.P38.Defs

variable (X : Type*) [TopologicalSpace X]

namespace UnstablePiBase.Formal

abbrev P38 := InjPathConnectedSpace

class NP38 (X : Type*) [TopologicalSpace X] where
  not_p38 : ¬ P38 X

end UnstablePiBase.Formal
