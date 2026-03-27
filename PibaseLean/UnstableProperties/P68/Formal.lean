import PibaseLean.UnstableProperties.P68.Defs

namespace PiBase.Formal

abbrev P68 := RothbergerSpace

class NP68 (X : Type*) [TopologicalSpace X] where
  not_p68 : ¬ P68 X

end PiBase.Formal
