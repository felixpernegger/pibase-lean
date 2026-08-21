module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P42.Defs

@[expose] public section

namespace PiBase

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem Homeomorph.locallyPathConnectedSpace [h : LocallyPathConnectedSpace X]
    (f : X ≃ₜ Y) : LocallyPathConnectedSpace Y :=
  f.symm.isOpenEmbedding.locallyPathConnectedSpace

theorem WellDefined.locallyPathConnectedSpace :
    WellDefined LocallyPathConnectedSpace :=
  fun {_ _} _ _ h _ ↦ Homeomorph.locallyPathConnectedSpace h.some

end PiBase
