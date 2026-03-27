import Mathlib

open Topology Set Function Filter TopologicalSpace

namespace UnstablePiBase

/- 82. Locally metrizable -/
class LocallyMetrizableSpace (X : Type*) [TopologicalSpace X] : Prop where
  locally_metrizable : ∀ (x : X), ∃ C : Set X, C ∈ 𝓝 x ∧ MetrizableSpace C

end UnstablePiBase
