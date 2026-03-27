import Mathlib

open Topology Set Function Filter TopologicalSpace

namespace UnstablePiBase

/- 44. Biconnected -/
class BiconnectedSpace (X : Type*) [TopologicalSpace X] : Prop where
  preconnected : PreconnectedSpace X
  no_partition : ∀ s v : Set X,
    ConnectedSpace s → encard s ≥ 2 → ConnectedSpace v → encard v ≥ 2 → (s ∩ v).Nonempty

end UnstablePiBase
