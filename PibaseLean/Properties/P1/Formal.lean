import PibaseLean.Properties.P1.Defs

namespace PiBase.Formal

abbrev P1 := T0Space

class NP1 (X : Type*) [TopologicalSpace X] where
  not_p1 : ¬ P1 X

end PiBase.Formal
