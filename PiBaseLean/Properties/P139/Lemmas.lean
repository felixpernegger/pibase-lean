module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P139.Defs

@[expose] public section

namespace PiBase

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem Homeomorph.hasAnIsolatedPoint [h : HasAnIsolatedPoint X] (f : X ≃ₜ Y) :
    HasAnIsolatedPoint Y where
  ex_isolated := by
    rcases h.ex_isolated with ⟨x, hx⟩
    exact ⟨f x, by
      have : IsOpen (f '' {x}) := f.isOpen_image.mpr hx
      rwa [Set.image_singleton] at this⟩

theorem WellDefined.hasAnIsolatedPoint : WellDefined HasAnIsolatedPoint :=
  fun {_ _} _ _ h _ ↦ Homeomorph.hasAnIsolatedPoint h.some

end PiBase
