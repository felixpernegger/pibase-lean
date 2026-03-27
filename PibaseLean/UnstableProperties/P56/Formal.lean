import PibaseLean.UnstableProperties.P56.Defs

namespace PiBase.Formal

abbrev P56 := MeagreSpace

class NP56 (X : Type*) [TopologicalSpace X] where
  not_p56 : ¬ P56 X

end PiBase.Formal
