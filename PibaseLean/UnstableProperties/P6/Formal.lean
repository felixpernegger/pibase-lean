import PibaseLean.UnstableProperties.P6.Defs

namespace PiBase.Formal

abbrev P6 := T35Space

class NP6 (X : Type*) [TopologicalSpace X] where
  not_p6 : ¬ P6 X

end PiBase.Formal
