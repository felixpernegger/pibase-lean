import PibaseLean.UnstableProperties.P16.Defs

namespace UnstablePiBase.Formal

abbrev P16 := CompactSpace

class NP16 (X : Type*) [TopologicalSpace X] where
  not_p16 : ¬ P16 X

end UnstablePiBase.Formal
