module

public import PiBaseLean.AdditionalDefs.Meta

@[expose] public section

namespace PiBase

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem Homeomorph.hereditarilyLindelofSpace [h : HereditarilyLindelofSpace X]
    (f : X ≃ₜ Y) : HereditarilyLindelofSpace Y where
  isHereditarilyLindelof_univ t _ := by
    have hL : IsLindelof (f ⁻¹' t) := HereditarilyLindelofSpace.isLindelof _
    have hI : IsLindelof (f '' (f ⁻¹' t)) := hL.image f.continuous
    rwa [f.image_preimage] at hI

theorem WellDefined.hereditarilyLindelofSpace : WellDefined HereditarilyLindelofSpace :=
  fun {_ _} _ _ h _ ↦ Homeomorph.hereditarilyLindelofSpace h.some

end PiBase
