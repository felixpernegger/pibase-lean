module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P74.Defs
public import PiBaseLean.Properties.P5.Bundled
public import PiBaseLean.Properties.P182.Bundled

@[expose] public section

namespace PiBase

open Topology Filter Set Function TopologicalSpace

section Meta


variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.cosmicSpace : WellDefined CosmicSpace :=
  fun {_ _} _ _ hXY h =>
    let φ := hXY.some
    @CosmicSpace.mk _ _ (WellDefined.t3Space.homeo φ h.toT3Space)
      (WellDefined.hasCountableNetwork.homeo φ h.toHasCountableNetwork)

end Meta

end PiBase
