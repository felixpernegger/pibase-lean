module

public import PiBaseLean.AdditionalDefs.Meta

@[expose] public section

namespace PiBase

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem Homeomorph.r0Space [h : R0Space X] (f : X ≃ₜ Y) : R0Space Y :=
  f.symm.isInducing.r0Space

theorem WellDefined.r0Space : WellDefined R0Space :=
  fun {_ _} _ _ h _ ↦ Homeomorph.r0Space h.some

end PiBase
