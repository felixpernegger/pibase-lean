module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P211.Defs

@[expose] public section

namespace PiBase

open Topology Filter Set Function TopologicalSpace

section Meta

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.α15Space : WellDefined α15Space :=
  fun {_ _} _ _ hXY hX => Formal.P211.well_defined hXY.some hX

end Meta

end PiBase
