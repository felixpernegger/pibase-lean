import Mathlib

open Topology Set Function Filter TopologicalSpace

namespace UnstablePiBase

/- 93. Locally countable -/
class LocallyCountableSpace (X : Type*) [TopologicalSpace X] : Prop where
  locally_countable : ∀ x : X, ∃ s ∈ 𝓝 x, s.Countable

end UnstablePiBase
