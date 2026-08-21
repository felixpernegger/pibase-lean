module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P75.Defs

@[expose] public section

namespace PiBase

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem Homeomorph.spectralSpace [h : SpectralSpace X] (f : X ≃ₜ Y) :
    SpectralSpace Y :=
  @f.symm.isOpenEmbedding.spectralSpace _ _ _ _ _ _ f.compactSpace

theorem WellDefined.spectralSpace : WellDefined SpectralSpace :=
  fun {_ _} _ _ h _ ↦ Homeomorph.spectralSpace h.some

end PiBase
