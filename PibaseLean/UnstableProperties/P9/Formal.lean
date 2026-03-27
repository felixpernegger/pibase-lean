import PibaseLean.UnstableProperties.P9.Defs

namespace UnstablePiBase.Formal

abbrev P9 := CompletelyT2Space

class NP1 (X : Type*) [TopologicalSpace X] where
  not_p9 : ¬ P9 X

end UnstablePiBase.Formal
