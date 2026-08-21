module

public import PiBaseLean.AdditionalDefs.Meta

@[expose] public section

namespace PiBase

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem Homeomorph.t5Space [T5Space X] (f : X ≃ₜ Y) : T5Space Y :=
  f.t5Space

theorem WellDefined.t5Space : WellDefined T5Space :=
  fun {_ _} _ _ h _ => Homeomorph.t5Space h.some

end PiBase
