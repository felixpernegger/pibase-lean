import PibaseLean.Properties.P21.Defs

variable (X : Type*) [TopologicalSpace X]

namespace PiBase.Formal

abbrev P21 := PrePathConnectedSpace

class NP21 (X : Type*) [TopologicalSpace X] where
  not_p21 : ¬ P21 X

end PiBase.Formal
