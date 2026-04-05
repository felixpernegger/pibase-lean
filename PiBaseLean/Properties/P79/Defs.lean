import Mathlib.Topology.Sequences
import PiBaseLean.Properties.Bundled.Defs

namespace PiBase

/- 79. Sequential -/
#check SequentialSpace

end PiBase

namespace PiBase.Formal

def P79 : Property where
  toPred := SequentialSpace
  well_defined' φ _ := φ.isQuotientMap.sequentialSpace

end PiBase.Formal
