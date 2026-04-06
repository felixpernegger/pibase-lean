import Mathlib.Topology.Metrizable.Basic
import PiBaseLean.Properties.Bundled.Defs

open Topology Set Filter Function

namespace PiBase

/- 210. α₁ space -/
class α1Space (X : Type*) [TopologicalSpace X] : Prop where
  subset_converge {x : X} {S : ℕ → ℕ → X} (S_inj : ∀ n, Injective (S n))
    (hS : ∀ n : ℕ, Tendsto (S n) atTop (𝓝 x)) : ∃ T : ℕ → X,
      Tendsto T atTop (𝓝 x) ∧ range T ⊆ ⋃ n, range (S n) ∧ ∀ n, (range (S n) \ range T).Finite

end PiBase

namespace PiBase.Formal

def P210 : Property where
  toPred := α1Space
  well_defined' φ h := sorry

end PiBase.Formal
