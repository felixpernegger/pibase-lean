module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P89.Defs

@[expose] public section

namespace PiBase

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.fixedPointSpace : WellDefined FixedPointSpace :=
  fun {X Y} _ _ hXY h => by
    let φ := hXY.some
    refine ⟨fun f ↦ ?_⟩
    rcases h.fixed_point (((φ.symm : C(Y, X)).comp f).comp (φ : C(X, Y))) with ⟨x, xfx⟩
    exact ⟨φ x, φ.symm_apply_eq.1 xfx⟩

end PiBase
