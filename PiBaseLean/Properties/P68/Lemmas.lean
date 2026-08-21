module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P68.Defs

@[expose] public section

namespace PiBase

open Set

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.rothbergerSpace : WellDefined RothbergerSpace :=
  fun {_ _} _ _ hXY h => by
    let φ := hXY.some
    constructor
    intro ι U hι hU_open hU_cover
    let U' : ℕ → ι → Set _ := fun n i => φ ⁻¹' (U n i)
    have hU'_open : ∀ n i, IsOpen (U' n i) := fun n i => φ.isOpen_preimage.mpr (hU_open n i)
    have hU'_cover : ∀ n, (⋃ i, U' n i) = univ := fun n => by
      have : (⋃ i, U' n i) = φ ⁻¹' (⋃ i, U n i) := by
        simp only [U', preimage_iUnion]
      rw [this, ← hU_cover n, preimage_univ]
    obtain ⟨j, hj⟩ := h.rothberger U' hι hU'_open (fun n => (hU'_cover n).symm)
    refine ⟨j, ?_⟩
    calc univ = φ '' univ := (image_univ_of_surjective φ.surjective).symm
      _ = φ '' (⋃ n, U' n (j n)) := by rw [← hj]
      _ = ⋃ n, φ '' (U' n (j n)) := by rw [image_iUnion]
      _ = ⋃ n, U n (j n) := by
          have h_eq : ∀ n, φ '' (U' n (j n)) = U n (j n) := fun n => φ.image_preimage (U n (j n))
          simp_rw [h_eq]

end PiBase
