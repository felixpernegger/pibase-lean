module

public import Mathlib.Topology.Homeomorph.Lemmas
public import Mathlib.Topology.MetricSpace.Pseudo.Defs

@[expose] public section

open Topology Set Function Filter TopologicalSpace

universe u

namespace PiBase

/- 122. Locally Euclidean -/
class LocallyEuclideanSpace (X : Type u) [TopologicalSpace X] : Prop where
  locally_homeomorph (x : X) : ∃ n : ℕ, ∃ s ∈ 𝓝 x, Nonempty (s ≃ₜ (Fin n → ℝ))

end PiBase
