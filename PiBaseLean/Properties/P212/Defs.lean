import Mathlib.Topology.Metrizable.Basic
import PiBaseLean.Properties.Bundled.Defs

open Topology Set Filter Function

namespace PiBase

/- 212. α₂ space -/
class α2Space (X : Type*) [τ : TopologicalSpace X] : Prop where
  subset_converge {x : X} {S : ℕ → ℕ → X} (S_inj : ∀ n, Injective (S n))
    (hS : ∀ n : ℕ, Tendsto (S n) atTop (𝓝 x)) : ∃ T : ℕ → X,
      Tendsto T atTop (𝓝 x) ∧ range T ⊆ ⋃ n, range (S n) ∧ ∀ n, (range (S n) ∩ range T).Infinite

end PiBase

namespace PiBase.Formal

def P212 : Property where
  toPred := α2Space
  well_defined φ h := sorry

end PiBase.Formal
