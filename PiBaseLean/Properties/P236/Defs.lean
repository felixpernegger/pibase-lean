module

public import Mathlib.Topology.Homeomorph.Lemmas
public import Mathlib.Topology.MetricSpace.Pseudo.Defs
public import Mathlib.Topology.Defs.Induced
public import PiBaseLean.AdditionalDefs.Meta

@[expose] public section

universe u

namespace PiBase

open Topology Filter Set Function

/- 236. Locally an n-Euclidean half-space -/
class LocallyNEuclideanHalfSpace (X : Type u) [TopologicalSpace X] : Prop where
  locally_homeomorph : ∃ n : ℕ, ∀ x : X, ∃ U ∈ 𝓝 x, ∃ (f : U → Fin n → NNReal), IsOpenEmbedding f

end PiBase
