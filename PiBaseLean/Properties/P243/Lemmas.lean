module

public import PiBaseLean.Properties.P243.Defs
public import PiBaseLean.AdditionalDefs.Meta

@[expose] public section

namespace PiBase

open Topology Filter Set

variable {X : Type*} [TopologicalSpace X]

section Meta

theorem WellDefined.hasCountablePiWeight : WellDefined HasCountablePiWeight :=
  sorry

end Meta

end PiBase
