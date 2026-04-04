import Mathlib.Topology.Metrizable.Basic

open Topology Set Filter Function

universe u

namespace PiBase

/- 212. α₂ space -/
class α2Space (X : Type u) [τ : TopologicalSpace X] : Prop where
  subset_converge {x : X} {S : ℕ → ℕ → X} (S_inj : ∀ n, Injective (S n))
    (hS : ∀ n : ℕ, Tendsto (S n) atTop (𝓝 x)) : ∃ T : ℕ → X,
      Tendsto T atTop (𝓝 x) ∧ range T ⊆ ⋃ n, range (S n) ∧ ∀ n, (range (S n) ∩ range T).Infinite

end PiBase
