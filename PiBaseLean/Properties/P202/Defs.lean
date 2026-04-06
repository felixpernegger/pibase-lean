import Mathlib.Topology.Defs.Filter
import PiBaseLean.Properties.Bundled.Defs

open Set Topology Filter

namespace PiBase

/- 202. Has a point with a unique neighborhood -/
class HasPointWithUniqueNeighborhood (X : Type*) [TopologicalSpace X] : Prop where
  ex_point_unique_nbhd : ∃ p : X, 𝓝 p = ⊤

end PiBase

namespace PiBase.Formal

def P202 : Property where
  toPred := HasPointWithUniqueNeighborhood
  well_defined' φ h := sorry

end PiBase.Formal
