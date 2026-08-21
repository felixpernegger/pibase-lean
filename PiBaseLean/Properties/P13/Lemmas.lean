module

public import PiBaseLean.AdditionalDefs.Meta

@[expose] public section

namespace PiBase

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem Homeomorph.normalSpace [NormalSpace X] (f : X ≃ₜ Y) : NormalSpace Y :=
  f.normalSpace

theorem WellDefined.normalSpace : WellDefined NormalSpace :=
  fun {_ _} _ _ h _ => Homeomorph.normalSpace h.some

end PiBase
