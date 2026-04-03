import Mathlib.Topology.Separation.Regular

namespace PiBase

/- 13. Normal -/
#check NormalSpace

end PiBase

namespace PiBase.Formal

abbrev P13 := NormalSpace

class NP13 (X : Type*) [TopologicalSpace X] where
  not_p13 : ¬ P13 X

end PiBase.Formal
