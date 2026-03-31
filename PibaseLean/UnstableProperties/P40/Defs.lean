import Mathlib

open Topology Set Function Filter TopologicalSpace

namespace UnstablePiBase

/- 40. Ultraconnected -/
class UltraconnectedSpace (X : Type*) [TopologicalSpace X] : Prop where
  ultraconnected : ∀ s v : Set X, IsClosed s → IsClosed v → s.Nonempty → v.Nonempty → (s ∩ v).Nonempty

end UnstablePiBase
