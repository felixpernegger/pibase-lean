import Mathlib.Topology.Metrizable.CompletelyMetrizable

open TopologicalSpace

namespace PiBase

/- 55. Completely metrizable -/
#check IsCompletelyMetrizableSpace

end PiBase

namespace PiBase.Formal

abbrev P55 := IsCompletelyMetrizableSpace

class NP55 (X : Type*) [TopologicalSpace X] where
  not_p55 : ¬ P55 X

end PiBase.Formal
