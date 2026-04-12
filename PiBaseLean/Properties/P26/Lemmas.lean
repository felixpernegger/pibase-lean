module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P26.Defs

@[expose] public section

namespace PiBase

open Topology Filter Set Function TopologicalSpace

section Meta

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem Homeomorph.separableSpace [SeparableSpace X] (f : X ≃ₜ Y) : SeparableSpace Y :=
  f.symm.isOpenEmbedding.separableSpace

theorem WellDefined.separableSpace : WellDefined SeparableSpace :=
  fun {_ _} _ _ h _ ↦ Homeomorph.separableSpace h.some

end Meta

end PiBase
