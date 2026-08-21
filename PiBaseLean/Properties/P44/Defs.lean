module

public import PiBaseLean.AdditionalDefs.Meta

@[expose] public section

universe u

namespace PiBase

/- 44. Biconnected -/
class BiconnectedSpace (X : Type*) [TopologicalSpace X] extends PreconnectedSpace X where
  no_partition : ∀ s v : Set X,
    ConnectedSpace s → s.Nontrivial → ConnectedSpace v → v.Nontrivial → (s ∩ v).Nonempty

end PiBase
