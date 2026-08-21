module

public import PiBaseLean.AdditionalDefs.Meta

@[expose] public section

namespace PiBase

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem Homeomorph.lindelofSpace [h : LindelofSpace X] (f : X ≃ₜ Y) : LindelofSpace Y :=
  LindelofSpace.of_continuous_surjective f.continuous f.surjective

theorem WellDefined.lindelofSpace : WellDefined LindelofSpace :=
  fun {_ _} _ _ h _ ↦ Homeomorph.lindelofSpace h.some

end PiBase
