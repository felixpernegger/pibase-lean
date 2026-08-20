module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P192.Defs

@[expose] public section

namespace PiBase

open Topology Filter Set Function TopologicalSpace

section Meta


variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.quasiSober : WellDefined QuasiSober :=
  fun {_ _} _ _ hXY _ =>
    let φ := hXY.some
    φ.symm.isClosedEmbedding.quasiSober

end Meta

end PiBase
