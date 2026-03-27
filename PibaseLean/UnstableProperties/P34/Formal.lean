import PibaseLean.UnstableProperties.P34.Defs

namespace PiBase.Formal

abbrev P34 := FullyNormalSpace

class NP34 (X : Type*) [TopologicalSpace X] where
  not_p34 : ¬ P34 X

end PiBase.Formal
