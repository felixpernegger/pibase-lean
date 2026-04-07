module

public import Mathlib.Topology.ExtremallyDisconnected
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

namespace PiBase

/- 49. Extremally disconnected -/
#check ExtremallyDisconnected

end PiBase

namespace PiBase.Formal

def P49 : Property where
  toPred := ExtremallyDisconnected
  well_defined φ _ := extremallyDisconnected_of_homeo φ

end PiBase.Formal
