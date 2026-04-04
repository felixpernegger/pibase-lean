import Mathlib.Topology.Separation.Regular

namespace PiBase

/- 8. T₅-Space -/
#check T5Space

end PiBase

namespace PiBase.Formal

abbrev P8 := T5Space

class NP8 (X : Type*) [TopologicalSpace X] where
  not_p1 : ¬ P8 X

end PiBase.Formal
