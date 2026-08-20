module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P49.Defs

@[expose] public section

namespace PiBase

open Topology Filter Set Function TopologicalSpace

section Meta

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.extremallyDisconnected : WellDefined ExtremallyDisconnected :=
  fun {_ _} _ _ h _ ↦ extremallyDisconnected_of_homeo h.some

end Meta

end PiBase
