import Mathlib

open Topology Set Function Filter TopologicalSpace

namespace PiBase

/- 40. Ultraconnected -/
class UltraconnectedSpace (X : Type*) [TopologicalSpace X] : Prop where
  ultraconnected : ∀ s v : Set X, IsClosed s → IsClosed v → (s ∩ v).Nonempty

end PiBase
