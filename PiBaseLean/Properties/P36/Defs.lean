import Mathlib.Topology.Connected.Basic

namespace PiBase

/- 36. Connected -/
#check PreconnectedSpace

end PiBase

namespace PiBase.Formal

abbrev P36 := PreconnectedSpace

class NP36 (X : Type*) [TopologicalSpace X] where
  not_p36 : ¬ P36 X

end PiBase.Formal
