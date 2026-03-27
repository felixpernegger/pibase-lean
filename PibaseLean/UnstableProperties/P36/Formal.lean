import PibaseLean.UnstableProperties.P36.Defs

namespace PiBase.Formal

abbrev P36 := ConnectedSpace

class NP36 (X : Type*) [TopologicalSpace X] where
  not_p36 : ¬ P36 X

end PiBase.Formal
