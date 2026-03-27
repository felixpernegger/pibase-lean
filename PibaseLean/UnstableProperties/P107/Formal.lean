import PibaseLean.UnstableProperties.P107.Defs

namespace PiBase.Formal

abbrev P107 := HasClosedPoint

class NP107 (X : Type*) [TopologicalSpace X] where
  not_p107 : ¬ P107 X

end PiBase.Formal
