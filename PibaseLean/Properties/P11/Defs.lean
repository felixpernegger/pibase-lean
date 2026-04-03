import Mathlib.Topology.Separation.Regular

namespace PiBase

/- 11. Regular -/
#check RegularSpace

end PiBase

namespace PiBase.Formal

abbrev P11 := RegularSpace

class NP11 (X : Type*) [TopologicalSpace X] where
  not_p11 : ¬ P11 X

end PiBase.Formal
