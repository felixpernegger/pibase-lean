module

public import PiBaseLean.AdditionalDefs.Meta

@[expose] public section

namespace PiBase

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem Homeomorph.sigmaCompactSpace [SigmaCompactSpace X] (f : X ≃ₜ Y) : SigmaCompactSpace Y :=
  f.symm.isClosedEmbedding.sigmaCompactSpace

theorem WellDefined.sigmaCompactSpace : WellDefined SigmaCompactSpace :=
  fun {_ _} _ _ h _ => Homeomorph.sigmaCompactSpace h.some

end PiBase
