import PibaseLean.UnstableProperties.P47.Defs

namespace PiBase.Formal

abbrev P47 := TotallyDisconnectedSpace

class NP47 (X : Type*) [TopologicalSpace X] where
  not_p47 : ¬ P47 X

end PiBase.Formal
