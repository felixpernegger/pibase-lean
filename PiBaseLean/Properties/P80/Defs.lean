import Mathlib.Topology.Defs.Sequences

namespace PiBase

/- 80. Frechet Urysohn -/
#check FrechetUrysohnSpace

end PiBase

namespace PiBase.Formal

abbrev P80 := FrechetUrysohnSpace

class NP80 (X : Type*) [TopologicalSpace X] where
  not_p80 : ¬ P80 X

end PiBase.Formal
