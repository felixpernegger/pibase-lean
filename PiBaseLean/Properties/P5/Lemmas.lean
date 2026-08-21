module

public import PiBaseLean.AdditionalDefs.Meta

@[expose] public section

namespace PiBase

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem Homeomorph.t3Space [T3Space X] (f : X ≃ₜ Y) : T3Space Y :=
  f.t3Space

theorem WellDefined.t3Space : WellDefined T3Space :=
  fun {_ _} _ _ h _ => Homeomorph.t3Space h.some

end PiBase
