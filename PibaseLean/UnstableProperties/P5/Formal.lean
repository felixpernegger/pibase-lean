import PibaseLean.Properties.P5.Defs

namespace PiBase.Formal

abbrev P5 := T3Space

class NP5 (X : Type*) [TopologicalSpace X] where
  not_p5 : ¬ P5 X

end PiBase.Formal
