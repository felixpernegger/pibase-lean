module

public import PiBaseLean.AdditionalDefs.Meta

@[expose] public section

namespace PiBase

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem Homeomorph.t25Space [T25Space X] (f : X ≃ₜ Y) : T25Space Y :=
  f.t25Space

theorem WellDefined.t25Space : WellDefined T25Space :=
  fun {_ _} _ _ h _ => Homeomorph.t25Space h.some

end PiBase
