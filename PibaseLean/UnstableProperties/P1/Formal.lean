import PibaseLean.UnstableProperties.P37.Defs

namespace PiBase.Formal

abbrev P37 := T0Space

class NP1 (X : Type*) [TopologicalSpace X] where
  not_p1 : ¬ P37 X

end PiBase.Formal
