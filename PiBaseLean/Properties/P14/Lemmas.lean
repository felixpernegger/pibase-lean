module

public import PiBaseLean.AdditionalDefs.Meta

@[expose] public section

namespace PiBase

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem Homeomorph.completelyNormalSpace [CompletelyNormalSpace X] (f : X ≃ₜ Y) :
    CompletelyNormalSpace Y :=
  f.symm.isEmbedding.completelyNormalSpace

theorem WellDefined.completelyNormalSpace : WellDefined CompletelyNormalSpace :=
  fun {_ _} _ _ h _ => Homeomorph.completelyNormalSpace h.some

end PiBase
