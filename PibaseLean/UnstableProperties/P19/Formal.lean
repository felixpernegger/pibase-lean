import PibaseLean.UnstableProperties.P19.Defs

namespace UnstablePiBase.Formal

abbrev P19 := CountablyCompactSpace

class NP19 (X : Type*) [TopologicalSpace X] where
  not_p19 : ¬ P19 X

end UnstablePiBase.Formal
