module

public import PiBaseLean.AdditionalDefs.Meta

@[expose] public section

namespace PiBase

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem Homeomorph.t1Space [T1Space X] (f : X ≃ₜ Y) : T1Space Y :=
  f.t1Space

theorem WellDefined.t1Space : WellDefined T1Space :=
  fun {_ _} _ _ h _ => Homeomorph.t1Space h.some

end PiBase
