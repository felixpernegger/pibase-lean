module

public import Mathlib.Topology.UniformSpace.Real

@[expose] public section

universe u

namespace PiBase

open Topology

/- 235. Locally a Euclidean half-space -/
class LocallyEuclideanHalfSpace (X : Type u) [TopologicalSpace X] : Prop where
  locally_homeomorph (x : X) : ∃ U ∈ 𝓝 x, ∃ (n : ℕ) (f : U → Fin n → NNReal), IsOpenEmbedding f

end PiBase
