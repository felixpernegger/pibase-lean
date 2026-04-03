import Mathlib.Topology.Separation.GDelta

namespace PiBase

/- 67. T6 -/
#check T6Space

end PiBase

namespace PiBase.Formal

abbrev P67 := T6Space

class NP67 (X : Type*) [TopologicalSpace X] where
  not_p67 : ¬ P67 X

end PiBase.Formal
