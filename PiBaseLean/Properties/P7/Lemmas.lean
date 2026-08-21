module

public import PiBaseLean.AdditionalDefs.Meta

@[expose] public section

namespace PiBase

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem Homeomorph.t4Space [T4Space X] (f : X ≃ₜ Y) : T4Space Y :=
  f.t4Space

theorem WellDefined.t4Space : WellDefined T4Space :=
  fun {_ _} _ _ h _ => Homeomorph.t4Space h.some

end PiBase
