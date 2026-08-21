module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P208.Defs

@[expose] public section

namespace PiBase

open TopologicalSpace

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.noetherianSpace : WellDefined NoetherianSpace :=
  fun {_ _} _ _ hXY _ =>
    let φ := hXY.some
    φ.symm.isInducing.noetherianSpace

end PiBase
