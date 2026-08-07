module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P186.Defs

@[expose] public section

namespace PiBase

open Topology Filter Set Function TopologicalSpace

section Meta

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.embedsInTopologicalWGroupSpace : WellDefined EmbedsInTopologicalWGroupSpace :=
  sorry

end Meta

end PiBase

