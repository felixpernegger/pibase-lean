import PibaseLean.UnstableProperties.P81.Defs

namespace PiBase.Formal

abbrev P81 := CountablyTightSpace

class NP81 (X : Type*) [TopologicalSpace X] where
  not_p81 : ¬ P81 X

end PiBase.Formal
