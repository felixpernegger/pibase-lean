module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P60.Defs

@[expose] public section

namespace PiBase

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem Homeomorph.stronglyConnectedSpace [h : StronglyConnectedSpace X] (f : X ≃ₜ Y) :
    StronglyConnectedSpace Y where
  strongly_connected g hg := by
    obtain ⟨r, hr⟩ := h.strongly_connected (g ∘ f) (hg.comp f.continuous)
    refine ⟨r, funext fun y ↦ ?_⟩
    obtain ⟨x, rfl⟩ := f.surjective y
    exact congr_fun hr x

theorem WellDefined.stronglyConnectedSpace : WellDefined StronglyConnectedSpace :=
  fun {_ _} _ _ h _ ↦ Homeomorph.stronglyConnectedSpace h.some

end PiBase
