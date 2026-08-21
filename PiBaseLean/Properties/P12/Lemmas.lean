module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P12.Defs

@[expose] public section

namespace PiBase

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem Homeomorph.completelyRegularSpace [CompletelyRegularSpace X] (f : X ≃ₜ Y) :
    CompletelyRegularSpace Y :=
  f.symm.isInducing.completelyRegularSpace

theorem WellDefined.completelyRegularSpace : WellDefined CompletelyRegularSpace :=
  fun {_ _} _ _ h _ => Homeomorph.completelyRegularSpace h.some

end PiBase
