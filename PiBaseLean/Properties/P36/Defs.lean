import Mathlib.Topology.Connected.Basic
import PiBaseLean.Properties.Bundled.Defs

namespace PiBase

/- 36. Connected -/
#check PreconnectedSpace

end PiBase

namespace PiBase.Formal

def P36 : Property where
  toPred := PreconnectedSpace
  well_defined' φ _ := by
    constructor
    convert isPreconnected_range φ.continuous
    simp only [EquivLike.range_eq_univ]

end PiBase.Formal
