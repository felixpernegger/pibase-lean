module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P80.Defs

@[expose] public section

namespace PiBase

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem Homeomorph.frechetUrysohnSpace [h : FrechetUrysohnSpace X] (f : X ≃ₜ Y) :
    FrechetUrysohnSpace Y :=
  f.symm.isInducing.frechetUrysohnSpace

theorem WellDefined.frechetUrysohnSpace : WellDefined FrechetUrysohnSpace :=
  fun {_ _} _ _ h _ ↦ Homeomorph.frechetUrysohnSpace h.some

end PiBase
