module

public import Mathlib.Topology.MetricSpace.Pseudo.Defs
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

open Topology Set Function Filter TopologicalSpace

universe u

namespace PiBase

/- 123. Locally n-Euclidean -/
class LocallyNEuclideanSpace (X : Type u) [TopologicalSpace X] : Prop where
  locally_homeomorph : ∃ n : ℕ, ∀ x : X, ∃ s ∈ 𝓝 x, Nonempty (s ≃ₜ (Fin n → ℝ))

end PiBase

namespace PiBase.Formal

def P123 : Property where
  toPred := LocallyNEuclideanSpace
  well_defined φ h := sorry

end PiBase.Formal
