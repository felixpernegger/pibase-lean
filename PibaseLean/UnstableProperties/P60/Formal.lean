import PibaseLean.UnstableProperties.P60.Defs

namespace PiBase.Formal

abbrev P60 := StronglyConnectedSpace

class NP60 (X : Type*) [TopologicalSpace X] where
  not_p60 : ¬ P60 X

end PiBase.Formal
