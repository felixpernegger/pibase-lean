module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P53.Defs

@[expose] public section

namespace PiBase

open TopologicalSpace

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem Homeomorph.metrizableSpace [h : MetrizableSpace X] (f : X ≃ₜ Y) :
    MetrizableSpace Y :=
  f.symm.isEmbedding.metrizableSpace

theorem WellDefined.metrizableSpace : WellDefined MetrizableSpace :=
  fun {_ _} _ _ h _ ↦ Homeomorph.metrizableSpace h.some

end PiBase
