import Mathlib

open Topology Set Function Filter TopologicalSpace

namespace UnstablePiBase

/- 44. Biconnected -/
class BiconnectedSpace (X : Type*) [TopologicalSpace X] : Prop where
  preconnected : PreconnectedSpace X
  no_partition : ∀ s v : Set X,
    ConnectedSpace s → s.Nontrivial → ConnectedSpace v → v.Nontrivial → (s ∩ v).Nonempty

end UnstablePiBase
