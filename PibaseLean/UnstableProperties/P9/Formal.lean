import PibaseLean.Properties.P9.Defs

namespace PiBase.Formal

abbrev P9 := CompletelyT2Space

class NP1 (X : Type*) [TopologicalSpace X] where
  not_p9 : ¬ P9 X

end PiBase.Formal
