import Mathlib.Topology.Separation.Regular

namespace PiBase

/- 4. T25-Space -/
#check T25Space

end PiBase

namespace PiBase.Formal

abbrev P4 := T2Space

class NP4 (X : Type*) [TopologicalSpace X] where
  not_p4 : ¬ P4 X

end PiBase.Formal
