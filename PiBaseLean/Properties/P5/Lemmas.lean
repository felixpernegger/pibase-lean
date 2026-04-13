module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P5.Defs

@[expose] public section

namespace PiBase

open Topology Filter Set Function TopologicalSpace

section Meta

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.t3Space : WellDefined T3Space :=
  sorry

end Meta

end PiBase
