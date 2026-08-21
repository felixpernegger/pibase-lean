module

public import Mathlib.Topology.MetricSpace.Pseudo.Defs

@[expose] public section

open Topology

universe u

namespace PiBase

/- 184. Embeddable into euclidean space -/
class EmbeddableInEuclideanSpace (X : Type u) [TopologicalSpace X] : Prop where
  embeddable : ∃ (n : ℕ) (f : X → Fin n → ℝ), IsEmbedding f

end PiBase
