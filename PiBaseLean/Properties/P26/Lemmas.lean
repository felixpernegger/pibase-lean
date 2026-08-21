module

public import PiBaseLean.AdditionalDefs.Meta

@[expose] public section

namespace PiBase

open TopologicalSpace

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem Homeomorph.separableSpace [SeparableSpace X] (f : X ≃ₜ Y) : SeparableSpace Y :=
  f.symm.isOpenEmbedding.separableSpace

theorem WellDefined.separableSpace : WellDefined SeparableSpace :=
  fun {_ _} _ _ h _ ↦ Homeomorph.separableSpace h.some

end PiBase
