import Mathlib

open Topology Set Function Filter TopologicalSpace

namespace UnstablePiBase

/- 100. KC Space -/
class KcSpace (X : Type*) [TopologicalSpace X] : Prop where
  kc : ∀ s : Set X, IsCompact s → IsClosed s

end UnstablePiBase
