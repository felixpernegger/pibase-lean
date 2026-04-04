import Mathlib.Topology.Defs.Sequences

namespace PiBase

/- 79. Sequential -/
#check SequentialSpace

end PiBase

namespace PiBase.Formal

abbrev P79 := SequentialSpace

class NP79 (X : Type*) [TopologicalSpace X] where
  not_p79 : ¬ P79 X

end PiBase.Formal
