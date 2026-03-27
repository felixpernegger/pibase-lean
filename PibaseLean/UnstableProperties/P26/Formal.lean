import PibaseLean.UnstableProperties.P37.Defs

open TopologicalSpace

namespace PiBase.Formal

abbrev P26 := SeparableSpace

class NP26 (X : Type*) [TopologicalSpace X] where
  not_p26 : ¬ P26 X

end PiBase.Formal
