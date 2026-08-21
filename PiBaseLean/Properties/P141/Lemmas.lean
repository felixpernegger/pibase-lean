module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P141.Defs

@[expose] public section

namespace PiBase

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.compactlyGeneratedSpace : WellDefined CompactlyGeneratedSpace :=
  fun {_ _} _ _ hXY h => by
    let φ := hXY.some
    have hX : CompactlyGeneratedSpace _ := h
    apply compactlyGeneratedSpace_of_isClosed
    intro s hs
    have h_pre_closed : IsClosed (φ ⁻¹' s) := by
      have : CompactlyGeneratedSpace _ := hX
      apply CompactlyGeneratedSpace.isClosed'
      intro K _ _ _ f hf
      have h_eq : f ⁻¹' (φ ⁻¹' s) = (φ ∘ f) ⁻¹' s := by ext; simp
      rw [h_eq]
      exact hs K (φ ∘ f) (φ.continuous.comp hf)
    have h_eq : s = φ '' (φ ⁻¹' s) := (φ.image_preimage s).symm
    rw [h_eq]
    exact φ.isClosed_image.mpr h_pre_closed

end PiBase
