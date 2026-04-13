module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P232.Defs

@[expose] public section

namespace PiBase

open Topology Filter Set Function TopologicalSpace

section Meta

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.lC1 : WellDefined LC1 :=
  sorry

end Meta

end PiBase
