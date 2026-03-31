import Mathlib

open Function Set Filter Topology TopologicalSpace Set.Notation


namespace UnstablePiBase

/- 24. Locally relatively compact -/
class LocallyRelativelyCompact (X : Type*) [TopologicalSpace X] : Prop where
  locally_relatively_compact : ∀ x : X, (𝓝 x).HasBasis (fun s => IsCompact (closure s)) id

end UnstablePiBase
