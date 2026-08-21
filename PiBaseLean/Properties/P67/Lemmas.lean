module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P67.Defs

@[expose] public section

namespace PiBase

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem Homeomorph.t6Space [T6Space X] (f : X ≃ₜ Y) : T6Space Y :=
  f.symm.isEmbedding.t6Space

theorem WellDefined.t6Space : WellDefined T6Space :=
  fun {_ _} _ _ h _ => Homeomorph.t6Space h.some

end PiBase
