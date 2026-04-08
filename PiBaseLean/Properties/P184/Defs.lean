module

public import Mathlib.Topology.MetricSpace.Pseudo.Defs
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

open Topology Set Function Filter TopologicalSpace

universe u

namespace PiBase

/- 184. Embeddable into euclidean space -/
class EmbeddableInEuclideanSpace (X : Type u) [TopologicalSpace X] : Prop where
  embeddable : ∃ (n : ℕ) (f : X → Fin n → ℝ), IsEmbedding f

end PiBase

namespace PiBase.Formal

def P184 : Property where
  toPred := EmbeddableInEuclideanSpace
  well_defined φ h := sorry

end PiBase.Formal
