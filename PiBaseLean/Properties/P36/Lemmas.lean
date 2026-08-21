module

public import PiBaseLean.AdditionalDefs.Meta

@[expose] public section

namespace PiBase

universe u v

variable {X : Type u} {Y : Type v} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.preconnectedSpace : WellDefined PreconnectedSpace :=
  fun {X Y} _ _ φ _ => by
    constructor
    convert isPreconnected_range φ.some.continuous
    simp only [EquivLike.range_eq_univ]

theorem Homeomorph.preconnectedSpace [PreconnectedSpace X] (f : X ≃ₜ Y) : PreconnectedSpace Y := by
  constructor
  convert isPreconnected_range f.continuous
  simp only [EquivLike.range_eq_univ]

end PiBase
