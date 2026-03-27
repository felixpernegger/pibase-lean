import PibaseLean.UnstableProperties.P54.Defs

namespace PiBase.Formal

abbrev P54 := HasSigmaLocallyFiniteBase

class NP54 (X : Type*) [TopologicalSpace X] where
  not_p54 : ¬ P54 X

end PiBase.Formal
