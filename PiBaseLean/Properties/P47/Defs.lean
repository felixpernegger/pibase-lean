module

public import Mathlib.Topology.Connected.TotallyDisconnected
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

namespace PiBase

/- 47. Totally disconnected -/
#check TotallyDisconnectedSpace

end PiBase

namespace PiBase.Formal

def P47 : Property where
  toPred := TotallyDisconnectedSpace
  well_defined φ h := by
    constructor
    convert φ.isEmbedding.isTotallyDisconnected_range.2 h
    simp only [EquivLike.range_eq_univ]

end PiBase.Formal
