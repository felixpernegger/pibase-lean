module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P206.Defs

@[expose] public section

namespace PiBase

open Topology Filter Set Function TopologicalSpace

section Meta

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.stronglyChoquetSpace : WellDefined StronglyChoquetSpace :=
  fun {_ _} _ _ hXY hX => Formal.P206.well_defined hXY.some hX

end Meta

end PiBase
