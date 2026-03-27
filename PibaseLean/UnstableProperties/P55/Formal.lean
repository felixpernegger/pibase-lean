import PibaseLean.UnstableProperties.P55.Defs

namespace PiBase.Formal

abbrev P55 := IsCompletelyMetrizableSpace

class NP55 (X : Type*) [TopologicalSpace X] where
  not_p55 : ¬ P55 X

end PiBase.Formal
