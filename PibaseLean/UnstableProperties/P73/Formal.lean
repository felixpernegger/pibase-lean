import PibaseLean.UnstableProperties.P73.Defs

namespace PiBase.Formal

abbrev P73 := SoberSpace

class NP73 (X : Type*) [TopologicalSpace X] where
  not_p73 : ¬ P73 X

end PiBase.Formal
