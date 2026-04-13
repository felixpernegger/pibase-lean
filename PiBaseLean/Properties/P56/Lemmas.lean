module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P56.Defs

@[expose] public section

namespace PiBase

open Topology Filter Set Function TopologicalSpace

section Meta

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.meagreSpace : WellDefined MeagreSpace :=
  sorry

end Meta

end PiBase
