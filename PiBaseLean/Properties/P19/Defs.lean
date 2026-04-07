module

public import Mathlib.Topology.Compactness.CountablyCompact
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

namespace PiBase

/- 19. Countably compact -/
#check CountablyCompactSpace

end PiBase

namespace PiBase.Formal

def P19 : Property where
  toPred := CountablyCompactSpace
  well_defined φ h := by
    constructor
    convert h.isCountablyCompact_univ.image φ.continuous
    simp only [Set.image_univ, EquivLike.range_eq_univ]

end PiBase.Formal
