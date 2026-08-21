module

public import PiBaseLean.AdditionalDefs.Meta

@[expose] public section

namespace PiBase

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem Homeomorph.t2Space [T2Space X] (f : X ≃ₜ Y) : T2Space Y :=
  f.t2Space

theorem WellDefined.t2Space : WellDefined T2Space :=
  fun {_ _} _ _ h _ => Homeomorph.t2Space h.some

end PiBase
