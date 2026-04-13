module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P209.Defs

@[expose] public section

namespace PiBase

open Topology Filter Set Function TopologicalSpace

section Meta

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.densityLeContinuum : WellDefined DensityLeContinuum :=
  sorry

end Meta

end PiBase
