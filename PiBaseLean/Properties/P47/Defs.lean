import Mathlib.Topology.Connected.TotallyDisconnected

namespace PiBase

/- 47. Totally disconnected -/
#check TotallyDisconnectedSpace

end PiBase

namespace PiBase.Formal

abbrev P47 := TotallyDisconnectedSpace

class NP47 (X : Type*) [TopologicalSpace X] where
  not_p47 : ¬ P47 X

end PiBase.Formal
