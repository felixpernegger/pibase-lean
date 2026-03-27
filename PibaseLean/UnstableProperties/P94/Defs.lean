import Mathlib

open Topology Set Function Filter TopologicalSpace

namespace UnstablePiBase

/- 94. Locally finite -/
class LocallyFiniteSpace (X : Type*) [TopologicalSpace X] : Prop where
  locally_finite : ∀ x : X, ∃ s ∈ 𝓝 x, s.Finite

end UnstablePiBase
