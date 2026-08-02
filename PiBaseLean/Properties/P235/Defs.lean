module

public import Mathlib.Topology.MetricSpace.Pseudo.Defs
public import Mathlib.Topology.Defs.Induced
public import PiBaseLean.Properties.Bundled.Defs
public import PiBaseLean.AdditionalDefs.Meta

@[expose] public section

universe u

namespace PiBase

open Filter Topology

/- 235. Locally a Euclidean half-space -/
class LocallyEuclideanHalfSpace (X : Type u) [TopologicalSpace X] : Prop where
  locally_homeomorph (x : X) : ∃ U ∈ 𝓝 x, ∃ (n : ℕ) (f : U → Fin n → NNReal), IsEmbedding f

end PiBase

namespace PiBase.Formal

def P235 : Property where
  toPred := LocallyEuclideanHalfSpace
  well_defined φ h := sorry

end PiBase.Formal
