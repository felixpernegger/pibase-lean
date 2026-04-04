import Mathlib.Topology.Connected.Basic

open Topology Set Function Filter TopologicalSpace

namespace PiBase

/- 44. Biconnected -/
class BiconnectedSpace (X : Type*) [TopologicalSpace X] extends PreconnectedSpace X where
  no_partition : ∀ s v : Set X,
    ConnectedSpace s → s.Nontrivial → ConnectedSpace v → v.Nontrivial → (s ∩ v).Nonempty

end PiBase
