module

public import Mathlib.Topology.Compactness.CompactlyCoherentSpace
public import PiBaseLean.AdditionalDefs.Meta

@[expose] public section

namespace PiBase

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.compactlyCoherentSpace : WellDefined CompactlyCoherentSpace :=
  fun {X Y} _ _ hXY h => by
    let φ := hXY.some
    -- h : CompactlyCoherentSpace X, φ : X ≃ₜ Y
    -- Need CompactlyCoherentSpace Y, i.e., IsCoherentWith {K | IsCompact K}
    constructor
    -- Coherence for Y: show IsCoherentWith (compact sets in Y)
    have hX_coh := h.isCoherentWith
    -- Want IsCoherentWith for Y
    refine ⟨fun t ht => ?_⟩
    -- ht : ∀ s ∈ {IsCompact}, IsOpen (Subtype.val ⁻¹' t)
    -- Need IsOpen t in Y
    -- Show IsOpen (φ ⁻¹' t) in X using coherence of X
    have h_pre_open : IsOpen (φ ⁻¹' t) := by
      rw [hX_coh.isOpen_iff]
      intro s hs
      -- s compact in X, need IsOpen (Subtype.val ⁻¹' (φ ⁻¹' t)) in s
      -- φ '' s compact in Y
      have h_s_image : IsCompact (φ '' s) := hs.image φ.continuous
      have hY := ht (φ '' s) h_s_image
      -- Transfer openness via homeomorph image s ≃ₜ φ '' s
      let e : s ≃ₜ φ '' s := φ.image s
      -- Show preimage relation
      have h_eq : (Subtype.val ⁻¹' (φ ⁻¹' t) : Set s) =
          e ⁻¹' (Subtype.val ⁻¹' t : Set (φ '' s)) := by
        ext ⟨x, hx⟩
        rfl
      rw [h_eq]
      exact e.isOpen_preimage.mpr hY
    exact φ.isOpen_preimage.mp h_pre_open

end PiBase
