import Mathlib.Order.Filter.Bases.Basic
import Mathlib.Topology.Defs.Filter

open Function Set Filter Topology TopologicalSpace

namespace PiBase

/- 24. Locally relatively compact -/
class LocallyRelativelyCompact (X : Type*) [TopologicalSpace X] : Prop where
  locally_relatively_compact : ∀ x : X, (𝓝 x).HasBasis (fun s => IsCompact (closure s)) id

end PiBase
