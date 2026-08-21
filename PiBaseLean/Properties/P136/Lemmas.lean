module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P136.Defs

@[expose] public section

namespace PiBase

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.anticompactSpace : WellDefined AnticompactSpace :=
  fun {X Y} _ _ hXY h => by
    let φ := hXY.some
    constructor
    intro s hs
    -- map compact s:Y through φ.symm to get compact preimage in X
    have h_eq : φ ⁻¹' s = φ.symm '' s := by
      ext x
      constructor
      · intro hx
        exact ⟨φ x, hx, by simp⟩
      · rintro ⟨y, hy, rfl⟩
        simp [hy]
    have hs' : IsCompact (φ ⁻¹' s) := by
      rw [h_eq]
      exact φ.symm.isCompact_image.mpr hs
    have hf := h.compact_finite _ hs'
    have h_pre : s = φ '' (φ ⁻¹' s) := (φ.image_preimage s).symm
    rw [h_pre]
    exact hf.image _

end PiBase
