import PibaseLean.UnstableProperties.P42.Defs

namespace PiBase.Formal

abbrev P42 := LocallyPathConnectedSpace

class NP42 (X : Type*) [TopologicalSpace X] where
  not_p42 : ¬ P42 X

end PiBase.Formal
