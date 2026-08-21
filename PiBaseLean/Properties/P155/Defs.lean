module

public import Mathlib.Topology.MetricSpace.Pseudo.Defs

@[expose] public section

open Topology

universe u

namespace PiBase

/- 155. Locally 1-Euclidean -/
class LocallyOneEuclideanSpace (X : Type u) [TopologicalSpace X] : Prop where
  locally_homeomorph : ∀ x : X, ∃ s ∈ 𝓝 x, Nonempty (s ≃ₜ ℝ)

end PiBase
