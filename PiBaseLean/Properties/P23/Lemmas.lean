module

public import PiBaseLean.AdditionalDefs.Meta

@[expose] public section

namespace PiBase

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem Homeomorph.weaklyLocallyCompactSpace [WeaklyLocallyCompactSpace X] (f : X ≃ₜ Y) :
    WeaklyLocallyCompactSpace Y :=
  f.symm.isClosedEmbedding.weaklyLocallyCompactSpace

theorem WellDefined.weaklyLocallyCompactSpace : WellDefined WeaklyLocallyCompactSpace :=
  fun {_ _} _ _ h _ => Homeomorph.weaklyLocallyCompactSpace h.some

end PiBase
