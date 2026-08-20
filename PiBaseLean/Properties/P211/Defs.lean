module

public import PiBaseLean.AdditionalDefs.AlphaTransport

@[expose] public section

open Topology Set Filter Function

namespace PiBase

/- 211. α₁.₅ space -/
class α15Space (X : Type*) [TopologicalSpace X] : Prop where
  subset_converge {x : X} {S : ℕ → ℕ → X} (S_inj : ∀ n, Injective (S n))
    (S_disj : Pairwise (fun n m ↦ range (S n) ∩ range (S m) = ∅))
    (hS : ∀ n : ℕ, Tendsto (S n) atTop (𝓝 x)) : ∃ T : ℕ → X, Injective T ∧
      Tendsto T atTop (𝓝 x) ∧ range T ⊆ ⋃ n, range (S n) ∧
        {n | (range (S n) \ range T).Finite}.Infinite

end PiBase
