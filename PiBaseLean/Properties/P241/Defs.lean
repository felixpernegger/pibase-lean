module

public import Mathlib.Topology.UniformSpace.Real

@[expose] public section

universe u

namespace PiBase

open Topology

/- 241. Locally a Euclidean half-line -/
class LocallyEuclideanHalfLine (X : Type u) [TopologicalSpace X] : Prop where
  locally_homeomorph (x : X): ∃ s ∈ 𝓝 x, ∃ f : s → NNReal, IsOpenEmbedding f

end PiBase
