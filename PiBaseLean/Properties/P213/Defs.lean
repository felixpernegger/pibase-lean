module

public import PiBaseLean.AdditionalDefs.AlphaTransport

@[expose] public section

open Topology Set Filter Function

namespace PiBase

/- 213. α₃ space -/
class α3Space (X : Type*) [τ : TopologicalSpace X] : Prop where
  subset_converge {x : X} {S : ℕ → ℕ → X} (S_inj : ∀ n, Injective (S n))
    (hS : ∀ n : ℕ, Tendsto (S n) atTop (𝓝 x)) : ∃ T : ℕ → X, Injective T ∧
      Tendsto T atTop (𝓝 x) ∧ range T ⊆ ⋃ n, range (S n) ∧
        {n | (range (S n) ∩ range T).Infinite}.Infinite

end PiBase
