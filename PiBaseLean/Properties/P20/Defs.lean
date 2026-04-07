module

public import Mathlib.Topology.Sequences
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

namespace PiBase

/- 20. Sequentially compact -/
#check SeqCompactSpace

end PiBase

namespace PiBase.Formal

def P20 : Property where
  toPred := SeqCompactSpace
  well_defined φ _ := by
    constructor
    convert IsSeqCompact.range φ.continuous.seqContinuous
    simp only [EquivLike.range_eq_univ]

end PiBase.Formal
