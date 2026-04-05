import Mathlib.Topology.AlexandrovDiscrete
import PiBaseLean.Properties.Bundled.Defs

namespace PiBase

/- 90. Alexandrov -/
#check AlexandrovDiscrete

end PiBase

namespace PiBase.Formal

def P90 : Property where
  toPred := AlexandrovDiscrete
  well_defined' φ _ := φ.symm.isInducing.alexandrovDiscrete

end PiBase.Formal
