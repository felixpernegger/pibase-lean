import Mathlib

open Function Set Filter Topology TopologicalSpace Set.Notation


namespace PiBase

/- 24. Locally relatively compact -/
class LocallyRelativelyCompact (X : Type*) [TopologicalSpace X] : Prop where
  locally_relatively_compact : ∀ x : X, ∃ B : Set (Set X),
    generate B = 𝓝 x ∧ ∀ s ∈ B, IsCompact (closure s)

end PiBase
