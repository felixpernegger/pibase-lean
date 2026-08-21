module

public import PiBaseLean.AdditionalDefs.Meta

@[expose] public section

namespace PiBase

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem Homeomorph.r1Space [h : R1Space X] (f : X ≃ₜ Y) : R1Space Y :=
  f.symm.isInducing.r1Space

theorem WellDefined.r1Space : WellDefined R1Space :=
  fun {_ _} _ _ h _ ↦ Homeomorph.r1Space h.some

end PiBase
