import Mathlib.Topology.Bases

namespace PiBase

/- 28. Second countable -/
#check FirstCountableTopology

end PiBase

open TopologicalSpace

namespace PiBase.Formal

abbrev P28 := FirstCountableTopology

class NP28 (X : Type*) [TopologicalSpace X] where
  not_p28 : ¬ P28 X

end PiBase.Formal
