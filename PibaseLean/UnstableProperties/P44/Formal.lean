import PibaseLean.UnstableProperties.P44.Defs

namespace PiBase.Formal

abbrev P44 := BiconnectedSpace

class NP44 (X : Type*) [TopologicalSpace X] where
  not_p44 : ¬ P44 X

end PiBase.Formal
