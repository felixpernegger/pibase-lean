import Mathlib.Topology.Connected.LocallyConnected

namespace PiBase

/- 41. Locally connected -/
#check LocallyConnectedSpace

end PiBase

namespace PiBase.Formal

abbrev P41 := LocallyConnectedSpace

class NP41 (X : Type*) [TopologicalSpace X] where
  not_p41 : ¬ P41 X

end PiBase.Formal
