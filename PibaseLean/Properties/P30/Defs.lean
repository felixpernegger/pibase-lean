import Mathlib.Topology.Compactness.Paracompact

open Topology

namespace PiBase

/- 30. Paracompact -/
#check ParacompactSpace

end PiBase

open TopologicalSpace

namespace PiBase.Formal

abbrev P30 := ParacompactSpace

class NP30 (X : Type*) [TopologicalSpace X] where
  not_p30 : ¬ P30 X

end PiBase.Formal
