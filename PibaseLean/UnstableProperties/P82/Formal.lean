import PibaseLean.UnstableProperties.P82.Defs

namespace PiBase.Formal

abbrev P82 := LocallyMetrizableSpace

class NP82 (X : Type*) [TopologicalSpace X] where
  not_p82 : ¬ P82 X

end PiBase.Formal
