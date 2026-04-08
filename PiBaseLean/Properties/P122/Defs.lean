module

public import Mathlib.Topology.MetricSpace.Pseudo.Defs
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

open Topology Set Function Filter TopologicalSpace

universe u

namespace PiBase

/- 122. Locally Euclidean -/
class LocallyEuclideanSpace (X : Type u) [TopologicalSpace X] : Prop where
  locally_homeomorph (x : X) : ∃ n : ℕ, ∃ s ∈ 𝓝 x, Nonempty (s ≃ₜ (Fin n → ℝ))

end PiBase

namespace PiBase.Formal

def P122 : Property where
  toPred := LocallyEuclideanSpace
  well_defined φ h := sorry

end PiBase.Formal
