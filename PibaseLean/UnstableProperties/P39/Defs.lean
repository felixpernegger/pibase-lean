import Mathlib

open Topology Set Function Filter TopologicalSpace

namespace UnstablePiBase

/- 39. Hyperconnected -/
class HyperconnectedSpace (X : Type*) [TopologicalSpace X] : Prop where
  hyperconnected : ∀ s v : Set X, IsOpen s → IsOpen v → (s ∩ v).Nonempty

end UnstablePiBase
