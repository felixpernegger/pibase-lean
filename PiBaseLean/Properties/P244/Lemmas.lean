module

public import PiBaseLean.Properties.P244.Defs
public import PiBaseLean.AdditionalDefs.Meta

@[expose] public section

namespace PiBase

open Topology Filter Set

variable {X : Type*} [TopologicalSpace X]

section Meta

theorem WellDefined.hasCountablePiCharacter : WellDefined HasCountablePiCharacter :=
  sorry

end Meta

end PiBase
