import PibaseLean.UnstableProperties.P40.Defs

namespace PiBase.Formal

abbrev P40 := UltraconnectedSpace

class NP40 (X : Type*) [TopologicalSpace X] where
  not_p40 : ¬ P40 X

end PiBase.Formal
