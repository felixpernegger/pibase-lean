import Mathlib.Topology.Bases

open TopologicalSpace

namespace PiBase

/- 180. Hereditarily separable -/
class HereditarilySeparableSpace (X : Type*) [TopologicalSpace X] : Prop where
  subset_separable (s : Set X) : SeparableSpace s

end PiBase
