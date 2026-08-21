module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P79.Defs

@[expose] public section

namespace PiBase

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem Homeomorph.sequentialSpace [h : SequentialSpace X] (f : X ≃ₜ Y) :
    SequentialSpace Y :=
  f.isQuotientMap.sequentialSpace

theorem WellDefined.sequentialSpace : WellDefined SequentialSpace :=
  fun {_ _} _ _ h _ ↦ Homeomorph.sequentialSpace h.some

end PiBase
