module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P101.Defs

@[expose] public section

namespace PiBase

open Set

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.hasClosedRetract : WellDefined HasClosedRetract :=
  fun {X Y} _ _ hXY h => by
    let φ := hXY.some
    refine ⟨fun s rs ↦ ?_⟩
    suffices r' : IsRetract (⇑φ ⁻¹' s) by simpa using h.has_closed_retract _ r'
    rcases rs with ⟨f, ff, rf⟩
    refine ⟨((φ.symm : C(Y, X)).comp f).comp (φ : C(X, Y)), ?_, ?_⟩
    · ext x
      simpa using DFunLike.congr_fun ff (φ x)
    · simp only [ContinuousMap.comp_assoc, ContinuousMap.coe_comp, ContinuousMap.coe_coe,
        range_comp, EquivLike.range_eq_univ, image_univ, ← rf]
      exact (φ.toEquiv.image_symm_eq_preimage s).symm

end PiBase
