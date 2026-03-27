import Mathlib

open Topology Set Function Filter TopologicalSpace

namespace UnstablePiBase

/- 97. Embeddable in ℝ -/
class EmbeddableInR (X : Type*) [TopologicalSpace X] : Prop where
  embeddable : ∃ f : X → ℝ, IsEmbedding f

end UnstablePiBase
