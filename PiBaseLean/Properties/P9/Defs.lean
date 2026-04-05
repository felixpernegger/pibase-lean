import Mathlib.Logic.Equiv.Pairwise
import Mathlib.Topology.UnitInterval
import PiBaseLean.Properties.Bundled.Defs

open Topology Set Function unitInterval
namespace PiBase

/- 9. Functionally Hausdorff -/
class FunctionallyT2Space (X : Type*) [TopologicalSpace X] : Prop where
  functionally_t2 : Pairwise fun x y : X ↦ ∃ f : C(X, I), f x = 0 ∧ f y = 1

end PiBase

namespace PiBase.Formal

def P9 : Property where
  toPred := FunctionallyT2Space
  well_defined' {X Y} _ _ φ h := by
    constructor
    rw [← EquivLike.pairwise_comp_iff φ]
    intro x y hxy
    rcases h.functionally_t2 hxy with ⟨f, f₀, f₁⟩
    refine ⟨f.comp (φ.symm : C(Y, X)), ?_, ?_⟩ <;> simpa

end PiBase.Formal
