module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P39.Defs

@[expose] public section

namespace PiBase

open Topology Filter Set Function TopologicalSpace

section Meta

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.preirreducibleSpace : WellDefined PreirreducibleSpace :=
  sorry

end Meta

end PiBase
