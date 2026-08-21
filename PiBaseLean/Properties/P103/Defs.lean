module

public import Mathlib.Topology.Compactness.CountablyCompact

@[expose] public section

namespace PiBase

/- 103. Stronlgy KC Space -/
class StronglyKcSpace (X : Type*) [TopologicalSpace X] : Prop where
  countablycompact_closed : ∀ s : Set X, IsCountablyCompact s → IsClosed s

end PiBase
