module

public import PiBaseLean.Properties.P188.Defs
public import PiBaseLean.Properties.P36.Lemmas

@[expose] public section

namespace PiBase

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.continuumSpace : WellDefined ContinuumSpace :=
  fun {_ _} _ _ hXY h =>
    let φ := hXY.some
    @ContinuumSpace.mk _ _ (WellDefined.preconnectedSpace.homeo φ h.toPreconnectedSpace)
        φ.compactSpace φ.t2Space

end PiBase
