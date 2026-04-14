module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P171.Defs

@[expose] public section

namespace PiBase

open Topology Filter Set Function TopologicalSpace

section Meta

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.k2T2Space : WellDefined K2T2Space :=
  sorry

end Meta

end PiBase
