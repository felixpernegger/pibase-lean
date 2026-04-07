module

public import Mathlib.Topology.Metrizable.Basic
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

open Topology Set Filter Function

namespace PiBase

/- 211. α₁.₅ space -/
class α15Space (X : Type*) [TopologicalSpace X] : Prop where
  subset_converge {x : X} {S : ℕ → ℕ → X} (S_inj : ∀ n, Injective (S n))
    (S_disj : Pairwise (fun n m ↦ range (S n) ∩ range (S m) = ∅))
    (hS : ∀ n : ℕ, Tendsto (S n) atTop (𝓝 x)) : ∃ T : ℕ → X,
      Tendsto T atTop (𝓝 x) ∧ range T ⊆ ⋃ n, range (S n) ∧
        ∀ᶠ n in atTop, (range (S n) \ range T).Finite

end PiBase

namespace PiBase.Formal

def P211 : Property where
  toPred := α15Space
  well_defined φ h := sorry

end PiBase.Formal
