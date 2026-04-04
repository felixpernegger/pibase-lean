import Mathlib.Topology.Defs.Sequences

namespace PiBase

/- 20. Sequentially compact -/
#check SeqCompactSpace

end PiBase

namespace PiBase.Formal

abbrev P20 := SeqCompactSpace

class NP20 (X : Type*) [TopologicalSpace X] where
  not_p20 : ¬ P20 X

end PiBase.Formal
