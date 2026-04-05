import Mathlib.Topology.Compactness.Paracompact

namespace PiBase

/- 30. Paracompact -/
#check ParacompactSpace

end PiBase

namespace PiBase.Formal

abbrev P30 := ParacompactSpace

class NP30 (X : Type*) [TopologicalSpace X] where
  not_p30 : ¬ P30 X

end PiBase.Formal
