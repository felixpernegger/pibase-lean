module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P90.Defs

@[expose] public section

namespace PiBase

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.alexandrovDiscrete : WellDefined AlexandrovDiscrete :=
  fun {_ _} _ _ hXY _ =>
    let φ := hXY.some
    φ.symm.isInducing.alexandrovDiscrete

end PiBase
