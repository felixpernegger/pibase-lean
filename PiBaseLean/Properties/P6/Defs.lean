import Mathlib.Topology.Separation.CompletelyRegular

namespace PiBase

/- 6. T35-Space -/
#check T35Space

end PiBase

namespace PiBase.Formal

abbrev P6 := T35Space

class NP6 (X : Type*) [TopologicalSpace X] where
  not_p6 : ¬ P6 X

end PiBase.Formal
