module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P195.Defs

@[expose] public section

namespace PiBase

open Topology Filter Set Function TopologicalSpace

section Meta


variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.stoneSpace : WellDefined StoneSpace :=
  fun {_ _} _ _ hXY _ =>
    let φ := hXY.some
    @StoneSpace.mk _ _ φ.compactSpace φ.t2Space φ.totallyDisconnectedSpace

end Meta

end PiBase
