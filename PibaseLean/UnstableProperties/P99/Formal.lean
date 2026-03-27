import PibaseLean.UnstableProperties.P99.Defs

namespace PiBase.Formal

abbrev P99 := UsSpace

class NP99 (X : Type*) [TopologicalSpace X] where
  not_p99 : ¬ P99 X

end PiBase.Formal
