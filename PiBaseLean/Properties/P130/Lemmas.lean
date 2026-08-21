module

public import PiBaseLean.AdditionalDefs.Meta

@[expose] public section

namespace PiBase

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem Homeomorph.locallyCompactSpace [h : LocallyCompactSpace X] (f : X ≃ₜ Y) :
    LocallyCompactSpace Y :=
  f.symm.isClosedEmbedding.locallyCompactSpace

theorem WellDefined.locallyCompactSpace : WellDefined LocallyCompactSpace :=
  fun {_ _} _ _ h _ ↦ Homeomorph.locallyCompactSpace h.some

end PiBase
