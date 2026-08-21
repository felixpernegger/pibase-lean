module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P142.Defs

@[expose] public section

namespace PiBase

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.k3Space : WellDefined K3Space :=
  fun {_ _} _ _ hXY h => by
    let φ := hXY.some
    have hX_coh := h.isCoherentWith
    constructor
    refine ⟨fun t ht => ?_⟩
    have h_pre_open : IsOpen (φ ⁻¹' t) := by
      rw [hX_coh.isOpen_iff]
      intro s hs
      have h_s_image_compact : IsCompact (φ '' s) := hs.2.image φ.continuous
      have h_s_image_t2 : T2Space (φ '' s) := by
        have : T2Space s := hs.1
        have e : s ≃ₜ φ '' s := φ.image s
        exact e.t2Space
      have hY := ht (φ '' s) ⟨h_s_image_t2, h_s_image_compact⟩
      let e : s ≃ₜ φ '' s := φ.image s
      have h_eq : (Subtype.val ⁻¹' (φ ⁻¹' t) : Set s) =
          e ⁻¹' (Subtype.val ⁻¹' t : Set (φ '' s)) := by
        ext ⟨x, hx⟩
        rfl
      rw [h_eq]
      exact e.isOpen_preimage.mpr hY
    exact φ.isOpen_preimage.mp h_pre_open

end PiBase
