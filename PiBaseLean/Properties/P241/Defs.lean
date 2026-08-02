module

public import Mathlib.Topology.MetricSpace.Pseudo.Defs
public import Mathlib.Topology.Defs.Induced
public import PiBaseLean.Properties.Bundled.Defs
public import PiBaseLean.AdditionalDefs.Meta

@[expose] public section

universe u

namespace PiBase

open Topology Filter

/- 241. Locally a Euclidean half-line -/
class LocallyEuclideanHalfLine (X : Type u) [TopologicalSpace X] : Prop where
  locally_homeomorph (x : X): ∃ s ∈ 𝓝 x, ∃ f : s → NNReal, IsEmbedding f

end PiBase

namespace PiBase.Formal

def P241 : Property where
  toPred := LocallyEuclideanHalfLine
  well_defined φ h := sorry

end PiBase.Formal
