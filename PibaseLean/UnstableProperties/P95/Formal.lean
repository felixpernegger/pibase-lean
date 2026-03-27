import PibaseLean.UnstableProperties.P95.Defs

namespace PiBase.Formal

abbrev P95 := ArcConnectedSpace

class NP95 (X : Type*) [TopologicalSpace X] where
  not_p95 : ¬ P95 X

end PiBase.Formal
