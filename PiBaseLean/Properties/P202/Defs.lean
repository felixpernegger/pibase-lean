import Mathlib.Topology.Defs.Filter

open Set Topology Filter

namespace PiBase

/- 202. Has a point with a unique neighborhood -/
class HasPointWithUniqueNeighborhood (X : Type*) [TopologicalSpace X] : Prop where
  ex_point_unique_nbhd : ∃ p : X, 𝓝 p = ⊤

end PiBase
