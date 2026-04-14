module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P36.Defs

@[expose] public section

namespace PiBase

open Topology Filter Set Function TopologicalSpace

section Meta

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.preconnectedSpace : WellDefined PreconnectedSpace :=
  sorry

end Meta

end PiBase
