import Mathlib.Topology.Connected.TotallyDisconnected

namespace PiBase

/- 48. Totally separated -/
#check TotallySeparatedSpace

end PiBase

namespace PiBase.Formal

abbrev P48 := TotallySeparatedSpace

class NP48 (X : Type*) [TopologicalSpace X] where
  not_p48 : ¬ P48 X

end PiBase.Formal
