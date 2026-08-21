module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P219.Defs

@[expose] public section

namespace PiBase

open Set

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.torontoSpace : WellDefined TorontoSpace :=
  fun {X Z} _ _ hXY h => by
    let φ := hXY.some
    constructor
    intro Y hcard
    -- Pull `Y` back along `φ`; the preimage is homeomorphic to `Y` and has the same cardinality.
    have himg : φ '' (φ ⁻¹' Y) = Y := image_preimage_eq Y φ.surjective
    let e : (φ ⁻¹' Y : Set X) ≃ₜ (Y : Set Z) :=
      (φ.image (φ ⁻¹' Y)).trans (Homeomorph.setCongr himg)
    have hcardX : Cardinal.mk (φ ⁻¹' Y : Set X) = Cardinal.mk X :=
      (Cardinal.mk_congr e.toEquiv).trans (hcard.trans (Cardinal.mk_congr φ.toEquiv).symm)
    obtain ⟨eX⟩ := h.toronto hcardX
    exact ⟨e.symm.trans (eX.trans φ)⟩

end PiBase
