import PibaseLean.Properties.P13.Defs

namespace PiBase.Formal

abbrev P13 := NormalSpace

class NP13 (X : Type*) [TopologicalSpace X] where
  not_p13 : ¬ P13 X

end PiBase.Formal
