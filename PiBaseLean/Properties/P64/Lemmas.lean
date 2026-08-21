module

public import PiBaseLean.AdditionalDefs.Meta

@[expose] public section

namespace PiBase

section Meta

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.baireSpace : WellDefined BaireSpace :=
  fun {_ _} _ _ h _ ↦ Homeomorph.baireSpace h.some

end Meta

end PiBase
