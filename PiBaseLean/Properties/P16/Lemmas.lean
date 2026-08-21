module

public import PiBaseLean.AdditionalDefs.Meta

@[expose] public section

namespace PiBase

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem Homeomorph.compactSpace [CompactSpace X] (f : X ≃ₜ Y) : CompactSpace Y :=
  f.compactSpace

theorem WellDefined.compactSpace : WellDefined CompactSpace :=
  fun {_ _} _ _ h _ => Homeomorph.compactSpace h.some

end PiBase
