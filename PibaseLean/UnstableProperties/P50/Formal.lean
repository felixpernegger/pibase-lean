import PibaseLean.UnstableProperties.P50.Defs

namespace PiBase.Formal

abbrev P50 := ZeroDimensionalSpace

class NP50 (X : Type*) [TopologicalSpace X] where
  not_p50 : ¬ P50 X

end PiBase.Formal
