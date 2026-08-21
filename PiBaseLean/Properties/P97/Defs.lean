module

public import Mathlib.Topology.MetricSpace.Pseudo.Defs

@[expose] public section

open Topology

namespace PiBase

/- 97. Embeddable in ℝ -/
class EmbeddableInR (X : Type*) [TopologicalSpace X] : Prop where
  embeddable : ∃ f : X → ℝ, IsEmbedding f

end PiBase
