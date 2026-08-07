module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P224.Defs

@[expose] public section

namespace PiBase

open Topology Filter Set Function TopologicalSpace

section Meta

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.weaklyLocallyContractibleSpace : WellDefined WeaklyLocallyContractibleSpace :=
  sorry

end Meta

end PiBase

