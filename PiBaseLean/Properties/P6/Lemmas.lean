module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P6.Defs

@[expose] public section

namespace PiBase

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem Homeomorph.t35Space [T35Space X] (f : X ≃ₜ Y) : T35Space Y :=
  f.symm.isEmbedding.t35Space

theorem WellDefined.t35Space : WellDefined T35Space :=
  fun {_ _} _ _ h _ => Homeomorph.t35Space h.some

end PiBase
