module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P56.Defs

@[expose] public section

namespace PiBase

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem Homeomorph.meagreSpace [h : MeagreSpace X] (f : X ≃ₜ Y) : MeagreSpace Y where
  meagre := by
    have h1 : IsMeagre (Set.univ (α := X)) := h.meagre
    have h2 : IsMeagre (f '' Set.univ) := f.isInducing.isMeagre_image h1
    convert h2 using 1
    simp only [Set.image_univ, EquivLike.range_eq_univ]

theorem WellDefined.meagreSpace : WellDefined MeagreSpace :=
  fun {_ _} _ _ h _ ↦ Homeomorph.meagreSpace h.some

end PiBase
