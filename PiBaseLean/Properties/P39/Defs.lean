import Mathlib.Topology.Irreducible
import PiBaseLean.Properties.Bundled.Defs

namespace PiBase

/- 39. Hyperconnected -/
#check PreirreducibleSpace

end PiBase

namespace PiBase.Formal

def P39 : Property where
  toPred := PreirreducibleSpace
  well_defined' φ _ := φ.surjective.preirreducibleSpace φ.continuous

end PiBase.Formal
