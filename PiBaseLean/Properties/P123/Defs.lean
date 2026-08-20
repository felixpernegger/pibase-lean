module

public import Mathlib.Topology.Homeomorph.Lemmas
public import Mathlib.Topology.MetricSpace.Pseudo.Defs

@[expose] public section

open Topology Set Function Filter TopologicalSpace

universe u

namespace PiBase

/- 123. Locally n-Euclidean -/
class LocallyNEuclideanSpace (X : Type u) [TopologicalSpace X] : Prop where
  locally_homeomorph : ∃ n : ℕ, ∀ x : X, ∃ s ∈ 𝓝 x, Nonempty (s ≃ₜ (Fin n → ℝ))

end PiBase
