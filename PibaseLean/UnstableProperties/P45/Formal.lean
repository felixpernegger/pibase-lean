import PibaseLean.UnstableProperties.P45.Defs

namespace PiBase.Formal

abbrev P45 := HasDispersionPoint

class NP45 (X : Type*) [TopologicalSpace X] where
  not_p45 : ¬ P45 X

end PiBase.Formal
