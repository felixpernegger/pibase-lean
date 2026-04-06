import Mathlib.Order.Filter.Bases.Basic
import Mathlib.Topology.Defs.Filter
import PiBaseLean.Properties.Bundled.Defs

open Function Set Filter Topology TopologicalSpace

namespace PiBase

/- 24. Locally relatively compact -/
class LocallyRelativelyCompactSpace (X : Type*) [TopologicalSpace X] : Prop where
  locally_relatively_compact : ∀ x : X, (𝓝 x).HasBasis (fun s => s ∈ 𝓝 x ∧ IsCompact (closure s)) id

end PiBase

namespace PiBase.Formal

def P24 : Property where
  toPred := LocallyRelativelyCompactSpace
  well_defined' φ h := sorry

end PiBase.Formal
