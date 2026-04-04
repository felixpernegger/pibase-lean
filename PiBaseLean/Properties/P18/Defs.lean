import Mathlib.Topology.Compactness.Lindelof

namespace PiBase

/- 18. Lindelöf -/
#check LindelofSpace

end PiBase

namespace PiBase.Formal

abbrev P18 := LindelofSpace

class NP18 (X : Type*) [TopologicalSpace X] where
  not_p18 : ¬ P18 X

end PiBase.Formal
