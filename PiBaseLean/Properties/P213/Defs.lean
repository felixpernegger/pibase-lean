import Mathlib.Topology.Metrizable.Basic

open Topology Set Filter Function

namespace PiBase

/- 213. α₃ space -/
class α3Space (X : Type*) [τ : TopologicalSpace X] : Prop where
  subset_converge {x : X} {S : ℕ → ℕ → X} (S_inj : ∀ n, Injective (S n))
    (hS : ∀ n : ℕ, Tendsto (S n) atTop (𝓝 x)) : ∃ T : ℕ → X,
      Tendsto T atTop (𝓝 x) ∧ range T ⊆ ⋃ n, range (S n) ∧
        ∀ᶠ n in atTop, (range (S n) ∩ range T).Infinite

end PiBase
