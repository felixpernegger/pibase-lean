module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P55.Defs

@[expose] public section

namespace PiBase

open TopologicalSpace

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem Homeomorph.isCompletelyMetrizableSpace [h : IsCompletelyMetrizableSpace X]
    (f : X ≃ₜ Y) : IsCompletelyMetrizableSpace Y :=
  f.symm.isClosedEmbedding.IsCompletelyMetrizableSpace

theorem WellDefined.isCompletelyMetrizableSpace : WellDefined IsCompletelyMetrizableSpace :=
  fun {_ _} _ _ h _ ↦ Homeomorph.isCompletelyMetrizableSpace h.some

end PiBase
