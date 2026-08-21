module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P119.Defs

@[expose] public section

namespace PiBase

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.stoneanSpace : WellDefined StoneanSpace :=
  fun {_ _} _ _ hXY _ =>
    let φ := hXY.some
    @StoneanSpace.mk _ _ φ.compactSpace
        (extremallyDisconnected_of_homeo φ) φ.t2Space

end PiBase
