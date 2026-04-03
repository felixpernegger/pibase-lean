import Mathlib.Topology.Bases

open TopologicalSpace

namespace PiBase

/- 26. Separable -/
#check SeparableSpace

end PiBase

open TopologicalSpace

namespace PiBase.Formal

abbrev P26 := SeparableSpace

class NP26 (X : Type*) [TopologicalSpace X] where
  not_p26 : ¬ P26 X

end PiBase.Formal
