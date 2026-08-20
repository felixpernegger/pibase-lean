module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P213.Defs

@[expose] public section

namespace PiBase

open Topology Filter Set Function TopologicalSpace

section Meta

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.α3Space : WellDefined α3Space :=
  fun {_ _} _ _ hXY hX => Formal.P213.well_defined hXY.some hX

end Meta

end PiBase
