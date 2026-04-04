import Mathlib.Topology.Separation.Regular

namespace PiBase

/- 7. T₄-Space -/
#check T4Space

end PiBase

namespace PiBase.Formal

abbrev P7 := T4Space

class NP7 (X : Type*) [TopologicalSpace X] where
  not_p7 : ¬ P7 X

end PiBase.Formal
