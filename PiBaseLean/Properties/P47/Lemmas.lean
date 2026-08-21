module

public import PiBaseLean.AdditionalDefs.Meta

@[expose] public section

namespace PiBase

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem Homeomorph.totallyDisconnectedSpace [h : TotallyDisconnectedSpace X]
    (f : X ≃ₜ Y) : TotallyDisconnectedSpace Y :=
  f.totallyDisconnectedSpace

theorem WellDefined.totallyDisconnectedSpace : WellDefined TotallyDisconnectedSpace :=
  fun {_ _} _ _ h _ ↦ Homeomorph.totallyDisconnectedSpace h.some

end PiBase
