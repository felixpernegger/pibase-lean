import Mathlib.Topology.Bases

namespace PiBase

/- 27. Second countable -/
#check SecondCountableTopology

end PiBase

open TopologicalSpace

namespace PiBase.Formal

abbrev P27 := SecondCountableTopology

class NP27 (X : Type*) [TopologicalSpace X] where
  not_p27 : ¬ P27 X

end PiBase.Formal
