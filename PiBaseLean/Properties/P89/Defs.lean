import Mathlib.Topology.ContinuousMap.Basic
import PiBaseLean.Properties.Bundled.Defs

open Topology Set Function TopologicalSpace

namespace PiBase

/- 89. Fixed point property -/
class FixedPointSpace (X : Type*) [TopologicalSpace X] : Prop where
  fixed_point : ∀ (f : X → X), Continuous f → ∃ x : X, f x = x

end PiBase

namespace PiBase.Formal

def P89 : Property where
  toPred := FixedPointSpace
  well_defined' {X Y} _ _ φ h := by
    refine ⟨fun f ↦ ?_⟩
    rcases h.fixed_point (((φ.symm : C(Y, X)).comp f).comp (φ : C(X, Y))) with ⟨x, xfx⟩
    exact ⟨φ x, φ.symm_apply_eq.1 xfx⟩

end PiBase.Formal
