module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P19.Defs

@[expose] public section

namespace PiBase

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.countablyCompactSpace : WellDefined CountablyCompactSpace :=
  fun {X Y} _ _ φ h => by
    constructor
    convert h.isCountablyCompact_univ.image φ.some.continuous
    simp only [Set.image_univ, EquivLike.range_eq_univ]

theorem Homeomorph.countablyCompactSpace [CountablyCompactSpace X] (f : X ≃ₜ Y) :
    CountablyCompactSpace Y := by
  constructor
  convert (inferInstance : CountablyCompactSpace X).isCountablyCompact_univ.image f.continuous
  simp only [Set.image_univ, EquivLike.range_eq_univ]

end PiBase
