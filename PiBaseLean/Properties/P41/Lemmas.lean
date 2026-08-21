module

public import PiBaseLean.AdditionalDefs.Meta

@[expose] public section

namespace PiBase

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem Homeomorph.locallyConnectedSpace [h : LocallyConnectedSpace X] (f : X ≃ₜ Y) :
    LocallyConnectedSpace Y :=
  f.symm.isOpenEmbedding.locallyConnectedSpace

theorem WellDefined.locallyConnectedSpace : WellDefined LocallyConnectedSpace :=
  fun {_ _} _ _ h _ ↦ Homeomorph.locallyConnectedSpace h.some

end PiBase
