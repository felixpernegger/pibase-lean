module

public import Mathlib.Topology.MetricSpace.Pseudo.Defs
public import Mathlib.Topology.Defs.Induced
public import PiBaseLean.Properties.Bundled.Defs
public import PiBaseLean.AdditionalDefs.Meta

@[expose] public section

universe u

namespace PiBase

open Topology Filter

/- 236. Locally an n-Euclidean half-space -/
class LocallyNEuclideanHalfSpace (X : Type u) [TopologicalSpace X] : Prop where
  locally_homeomorph : ∃ n : ℕ, ∀ x : X, ∃ U ∈ 𝓝 x, ∃ (f : U → Fin n → NNReal), IsEmbedding f

end PiBase

namespace PiBase.Formal

def P236 : Property where
  toPred := LocallyNEuclideanHalfSpace
  well_defined φ h := sorry

end PiBase.Formal
