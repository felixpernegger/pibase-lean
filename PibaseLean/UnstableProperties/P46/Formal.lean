import PibaseLean.UnstableProperties.P46.Defs

namespace PiBase.Formal

abbrev P46 := TotallyPathDisconnectedSpace

class NP46 (X : Type*) [TopologicalSpace X] where
  not_p46 : ¬ P46 X

end PiBase.Formal
