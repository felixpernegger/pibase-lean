module

public import PiBaseLean.Properties.P5.Lemmas
public import PiBaseLean.Properties.P74.Defs

import PiBaseLean.Properties.P182.Lemmas

@[expose] public section

namespace PiBase

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.cosmicSpace : WellDefined CosmicSpace :=
  fun {_ _} _ _ hXY h =>
    let φ := hXY.some
    @CosmicSpace.mk _ _ (WellDefined.t3Space.homeo φ h.toT3Space)
      (WellDefined.hasCountableNetwork.homeo φ h.toHasCountableNetwork)

end PiBase
