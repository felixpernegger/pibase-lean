module

public import Mathlib.Topology.UniformSpace.Real

@[expose] public section

universe u

namespace PiBase

open Topology

/- 236. Locally an n-Euclidean half-space -/
class LocallyNEuclideanHalfSpace (X : Type u) [TopologicalSpace X] : Prop where
  locally_homeomorph : ∃ n : ℕ, ∀ x : X, ∃ U ∈ 𝓝 x, ∃ (f : U → Fin n → NNReal), IsOpenEmbedding f

end PiBase
