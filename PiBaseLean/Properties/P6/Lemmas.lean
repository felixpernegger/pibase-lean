module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P6.Defs

@[expose] public section

namespace PiBase

open Topology Filter Set Function TopologicalSpace

section Meta

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.t35Space : WellDefined T35Space :=
  sorry

end Meta

end PiBase
