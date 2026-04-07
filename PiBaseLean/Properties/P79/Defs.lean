module

public import Mathlib.Topology.Sequences
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

namespace PiBase

/- 79. Sequential -/
#check SequentialSpace

end PiBase

namespace PiBase.Formal

def P79 : Property where
  toPred := SequentialSpace
  well_defined φ _ := φ.isQuotientMap.sequentialSpace

end PiBase.Formal
