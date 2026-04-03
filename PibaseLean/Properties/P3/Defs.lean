import Mathlib.Topology.Separation.Hausdorff

namespace PiBase

/- 3. T2-Space -/
#check T2Space

end PiBase

namespace PiBase.Formal

abbrev P3 := T2Space

class NP3 (X : Type*) [TopologicalSpace X] where
  not_p3 : ¬ P3 X

end PiBase.Formal
