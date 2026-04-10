module

public import Mathlib.Topology.MetricSpace.Pseudo.Defs
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

open Topology Set Filter TopologicalSpace

universe u

namespace PiBase

/- 155. Locally 1-Euclidean -/
class LocallyOneEuclideanSpace (X : Type u) [TopologicalSpace X] : Prop where
  locally_homeomorph : ∀ x : X, ∃ s ∈ 𝓝 x, Nonempty (s ≃ₜ ℝ)

end PiBase

namespace PiBase.Formal

def P155 : Property where
  toPred := LocallyOneEuclideanSpace
  well_defined φ h := sorry

end PiBase.Formal
