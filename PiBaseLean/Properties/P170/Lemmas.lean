module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P170.Defs

@[expose] public section

namespace PiBase

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.k1T2Space : WellDefined K1T2Space :=
  fun {X Y} _ _ hXY h => by
    let φ := hXY.some
    constructor
    intro s hs
    -- Pull compact s ⊆ Y back to X via φ.symm; compactness preserved by continuous image
    have hK : IsCompact (φ.symm '' s) := hs.image φ.symm.continuous
    have hT2 : T2Space (φ.symm '' s) := h.compact_t2 _ hK
    -- Restricted homeomorphism (φ.symm '' s) ≃ₜ s transports T₂
    have e : (φ.symm '' s : Set _) ≃ₜ (s : Set _) := (φ.symm.image s).symm
    exact e.t2Space (X := (φ.symm '' s : Set _)) (Y := (s : Set _))

end PiBase
