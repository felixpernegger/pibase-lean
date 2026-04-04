import Mathlib.Topology.Compactness.SigmaCompact

namespace PiBase

/- 17. σ-compact -/
#check SigmaCompactSpace

end PiBase

namespace PiBase.Formal

abbrev P17 := SigmaCompactSpace

class NP17 (X : Type*) [TopologicalSpace X] where
  not_p17 : ¬ P17 X

end PiBase.Formal
