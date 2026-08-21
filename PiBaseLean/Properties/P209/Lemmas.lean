module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P209.Defs

@[expose] public section

namespace PiBase

open Cardinal

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.densityLeContinuum : WellDefined DensityLeContinuum :=
  fun {_ _} _ _ hXY h => by
    let φ := hXY.some
    obtain ⟨s, hDense, hLe⟩ := h.ex_dense
    refine ⟨φ '' s, ?_, ?_⟩
    · intro y
      have hmem : φ.symm y ∈ closure s := hDense (φ.symm y)
      have hmem' : y ∈ φ '' closure s := by
        rw [Set.mem_image]
        exact ⟨φ.symm y, hmem, φ.apply_symm_apply y⟩
      rw [φ.image_closure] at hmem'
      exact hmem'
    · have hEq : #(φ '' s) = #s := Cardinal.mk_image_eq φ.injective
      calc #(φ '' s) = #s := hEq
        _ ≤ 𝔠 := hLe

end PiBase
