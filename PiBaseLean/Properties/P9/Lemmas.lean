module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P9.Defs

import Mathlib.Logic.Equiv.Pairwise

@[expose] public section

namespace PiBase

universe u v

variable {X : Type u} {Y : Type v} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.functionallyT2Space : WellDefined FunctionallyT2Space :=
  fun {X Y} _ _ φ h => by
    constructor
    rw [← EquivLike.pairwise_comp_iff φ.some]
    intro x y hxy
    rcases h.functionally_t2 hxy with ⟨f, f₀, f₁⟩
    refine ⟨f.comp (φ.some.symm : C(Y, X)), ?_, ?_⟩ <;> simpa

theorem Homeomorph.functionallyT2Space [h : FunctionallyT2Space X] (f : X ≃ₜ Y) :
    FunctionallyT2Space Y := by
  constructor
  rw [← EquivLike.pairwise_comp_iff f]
  intro x y hxy
  rcases h.functionally_t2 hxy with ⟨g, g₀, g₁⟩
  refine ⟨g.comp (f.symm : C(Y, X)), ?_, ?_⟩ <;> simpa

end PiBase
