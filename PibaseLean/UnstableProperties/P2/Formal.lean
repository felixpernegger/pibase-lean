import PibaseLean.UnstableProperties.P2.Defs

namespace PiBase.Formal

abbrev P2 := T1Space

class NP2 (X : Type*) [TopologicalSpace X] where
  not_p2 : ¬ P2 X

end PiBase.Formal
