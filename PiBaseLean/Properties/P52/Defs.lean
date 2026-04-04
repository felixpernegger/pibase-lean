import Mathlib.Topology.Order

namespace PiBase

/- 52. Discrete -/
#check DiscreteTopology

end PiBase

namespace PiBase.Formal

abbrev P52 := DiscreteTopology

class NP52 (X : Type*) [TopologicalSpace X] where
  not_p52 : ¬ P52 X

end PiBase.Formal
