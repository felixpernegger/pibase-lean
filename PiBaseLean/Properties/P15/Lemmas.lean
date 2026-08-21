module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P15.Defs

@[expose] public section

namespace PiBase

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem Homeomorph.perfectlyNormalSpace [PerfectlyNormalSpace X] (f : X ≃ₜ Y) :
    PerfectlyNormalSpace Y :=
  f.symm.isInducing.perfectlyNormalSpace

theorem WellDefined.perfectlyNormalSpace : WellDefined PerfectlyNormalSpace :=
  fun {_ _} _ _ h _ ↦ Homeomorph.perfectlyNormalSpace h.some

end PiBase
