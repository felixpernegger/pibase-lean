module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P217.Defs

@[expose] public section

namespace PiBase

open Set

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.stronglyZeroDimensionalSpace : WellDefined StronglyZeroDimensionalSpace :=
  fun {_ Y} _ _ hXY h => by
    let φ := hXY.some
    constructor
    intro s t hs ht hdisj
    have key : ∀ {r : Set Y}, IsZero r → IsZero (φ ⁻¹' r) := by
      rintro r ⟨f, hf⟩
      refine ⟨⟨f ∘ φ, f.continuous.comp φ.continuous⟩, ?_⟩
      rw [← hf]
      rfl
    have hdisjX : φ ⁻¹' s ∩ φ ⁻¹' t = ∅ := by
      rw [← preimage_inter, hdisj, preimage_empty]
    obtain ⟨sX', tX', hsXc, htXc, hsXsub, htXsub, hXdisj⟩ :=
      h.disjoint_clopen (key hs) (key ht) hdisjX
    refine ⟨φ '' sX', φ '' tX', ?_, ?_, ?_, ?_, ?_⟩
    · exact ⟨φ.isClosedMap sX' hsXc.1, φ.isOpenMap sX' hsXc.2⟩
    · exact ⟨φ.isClosedMap tX' htXc.1, φ.isOpenMap tX' htXc.2⟩
    · calc s = φ '' (φ ⁻¹' s) := (φ.image_preimage s).symm
        _ ⊆ φ '' sX' := image_mono hsXsub
    · calc t = φ '' (φ ⁻¹' t) := (φ.image_preimage t).symm
        _ ⊆ φ '' tX' := image_mono htXsub
    · rw [← image_inter φ.injective, hXdisj, image_empty]

end PiBase
