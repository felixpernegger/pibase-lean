module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P66.Defs

@[expose] public section

namespace PiBase

open Set

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.mengerSpace : WellDefined MengerSpace :=
  fun {_ _} _ _ hXY h => by
    let φ := hXY.some
    constructor
    intro ι U hU_open hU_cover
    let U' : ℕ → ι → Set _ := fun n i => φ ⁻¹' (U n i)
    have hU'_open : ∀ n i, IsOpen (U' n i) := fun n i => φ.isOpen_preimage.mpr (hU_open n i)
    have hU'_cover : ∀ n, (⋃ i, U' n i) = univ := fun n => by
      have : (⋃ i, U' n i) = φ ⁻¹' (⋃ i, U n i) := by
        simp only [U', preimage_iUnion]
      rw [this, ← hU_cover n, preimage_univ]
    obtain ⟨s, hs⟩ := h.menger U' hU'_open (fun n => (hU'_cover n).symm)
    refine ⟨s, ?_⟩
    calc univ = φ '' univ := (image_univ_of_surjective φ.surjective).symm
      _ = φ '' (⋃ n, ⋃ i ∈ s n, U' n i) := by rw [← hs]
      _ = ⋃ n, ⋃ i ∈ s n, φ '' (U' n i) := by
          simp only [image_iUnion]
      _ = ⋃ n, ⋃ i ∈ s n, U n i := by
          have h_eq : ∀ n i, φ '' (U' n i) = U n i := fun n i => φ.image_preimage (U n i)
          simp_rw [h_eq]

end PiBase
