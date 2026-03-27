import PibaseLean.UnstableProperties.P78.Defs

namespace PiBase.Formal

abbrev P78 := Finite

class NP78 (X : Type*) [TopologicalSpace X] where
  not_p78 : ¬ P78 X

end PiBase.Formal
