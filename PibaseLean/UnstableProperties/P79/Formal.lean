import PibaseLean.UnstableProperties.P79.Defs

namespace PiBase.Formal

abbrev P79 := SequentialSpace

class NP79 (X : Type*) [TopologicalSpace X] where
  not_p79 : ¬ P79 X

end PiBase.Formal
