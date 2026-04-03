import Mathlib.Topology.Separation.Regular

namespace PiBase

/- 14. Completely normal -/
#check CompletelyNormalSpace

end PiBase

namespace PiBase.Formal

abbrev P14 := CompletelyNormalSpace

class NP14 (X : Type*) [TopologicalSpace X] where
  not_p14 : ¬ P14 X

end PiBase.Formal
