module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P62.Defs

@[expose] public section

namespace PiBase

open Set

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.weaklyLindelofSpace : WellDefined WeaklyLindelofSpace :=
  fun {X Y} _ _ hXY h => by
    let φ := hXY.some
    constructor
    intro ι U hU_open hU_cover
    let U' : ι → Set _ := fun i => φ ⁻¹' (U i)
    have hU'_open : ∀ i, IsOpen (U' i) := fun i => φ.isOpen_preimage.mpr (hU_open i)
    have hU'_cover : (⋃ i, U' i) = univ := by
      have : (⋃ i, U' i) = φ ⁻¹' (⋃ i, U i) := by
        simp only [U', preimage_iUnion]
      rw [this, hU_cover, preimage_univ]
    obtain ⟨t, ht_count, ht_dense⟩ := h.weakly_lindelof U' hU'_open hU'_cover
    refine ⟨t, ht_count, ?_⟩
    -- Dense transfer: closure of union in Y is image of closure in X via homeomorph
    have h_dense_X : Dense (⋃ i ∈ t, U' i) := ht_dense
    have h_closure_X : closure (⋃ i ∈ t, U' i) = univ := h_dense_X.closure_eq
    have h_img : φ '' (⋃ i ∈ t, U' i) = ⋃ i ∈ t, U i := by
      simp only [U', image_iUnion, φ.image_preimage]
    have h_closure_Y : closure (⋃ i ∈ t, U i) = univ := by
      calc closure (⋃ i ∈ t, U i)
          = closure (φ '' (⋃ i ∈ t, U' i)) := by rw [h_img]
        _ = φ '' closure (⋃ i ∈ t, U' i) := by rw [φ.image_closure]
        _ = φ '' univ := by rw [h_closure_X]
        _ = univ := image_univ_of_surjective φ.surjective
    exact dense_iff_closure_eq.mpr h_closure_Y

end PiBase
