module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P169.Defs

@[expose] public section

namespace PiBase

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.semiT2Space : WellDefined SemiT2Space :=
  fun {_ _} _ _ hXY h => by
    let φ := hXY.some
    refine ⟨fun y₁ y₂ hne => ?_⟩
    obtain ⟨s, hs_reg, hs_mem, hs_nmem⟩ :=
      h.ex_regular_open (φ.symm.injective.ne hne)
    refine ⟨φ '' s, ?_, ⟨φ.symm y₁, hs_mem, by simp⟩, ?_⟩
    · change interior (closure (φ '' s)) = φ '' s
      rw [← φ.image_closure, ← φ.image_interior, hs_reg]
    · rintro ⟨x, hx, rfl⟩
      exact hs_nmem (by simpa using hx)

end PiBase
