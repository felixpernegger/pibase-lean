module

public import PiBaseLean.AdditionalDefs.Meta

@[expose] public section

namespace PiBase

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem Homeomorph.t0Space [T0Space X] (f : X ≃ₜ Y) : T0Space Y :=
  f.t0Space

theorem WellDefined.t0Space : WellDefined T0Space :=
  fun {_ _} _ _ h _ => Homeomorph.t0Space h.some

end PiBase
