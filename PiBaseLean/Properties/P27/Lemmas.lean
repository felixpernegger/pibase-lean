module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P27.Defs

@[expose] public section

namespace PiBase

open Topology Filter Set Function TopologicalSpace

section Meta

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.secondCountableTopology : WellDefined SecondCountableTopology :=
  sorry

end Meta

end PiBase
