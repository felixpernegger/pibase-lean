import Mathlib.Topology.Metrizable.Basic

open Topology Set Filter Function

universe u

namespace PiBase

/- 211. α₁.₅ space -/
class α15Space (X : Type u) [TopologicalSpace X] : Prop where
  subset_converge {x : X} {S : ℕ → ℕ → X} (S_inj : ∀ n, Injective (S n))
    (S_disj : Pairwise (fun n m ↦ range (S n) ∩ range (S m) = ∅))
    (hS : ∀ n : ℕ, Tendsto (S n) atTop (𝓝 x)) : ∃ T : ℕ → X,
      Tendsto T atTop (𝓝 x) ∧ range T ⊆ ⋃ n, range (S n) ∧
        ∀ᶠ n in atTop, (range (S n) \ range T).Finite

end PiBase
