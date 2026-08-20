module

public import Mathlib.Topology.MetricSpace.Pseudo.Defs
public import Mathlib.Topology.Homeomorph.Lemmas

@[expose] public section

open Topology Set Function Filter TopologicalSpace

universe u

namespace PiBase

/- 155. Locally 1-Euclidean -/
class LocallyOneEuclideanSpace (X : Type u) [TopologicalSpace X] : Prop where
  locally_homeomorph : ∀ x : X, ∃ s ∈ 𝓝 x, Nonempty (s ≃ₜ ℝ)

end PiBase
