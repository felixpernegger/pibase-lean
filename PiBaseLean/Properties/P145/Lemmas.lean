module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P145.Defs

@[expose] public section

namespace PiBase

open Set

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.stronglyParacompactSpace : WellDefined StronglyParacompactSpace :=
  fun {X Y} _ _ hXY h => by
    let φ := hXY.some
    constructor
    intro α s hs_open hs_cover
    -- Transfer open cover s of Y to X via preimage
    let s' : α → Set _ := fun a => φ ⁻¹' (s a)
    have hs'_open : ∀ a, IsOpen (s' a) := fun a => φ.isOpen_preimage.mpr (hs_open a)
    have hs'_cover : (⋃ a, s' a) = univ := by
      rw [← preimage_iUnion]
      rw [hs_cover, preimage_univ]
    obtain ⟨β, t, ht_open, ht_cover, ht_sf, ht_ref⟩ :=
      h.starFinite_refinement α s' hs'_open hs'_cover
    -- Transfer t back to Y via image
    let t' : β → Set _ := fun b => φ '' (t b)
    refine ⟨β, t', fun b => φ.isOpen_image.mpr (ht_open b), ?_, ?_, ?_⟩
    · -- cover Y
      have : (⋃ b, t' b) = φ '' (⋃ b, t b) := by rw [image_iUnion]
      rw [this, ht_cover, image_univ_of_surjective φ.surjective]
    · -- star finite preservation
      intro i
      have h_eq : {j | (t' j ∩ t' i).Nonempty} = {j | (t j ∩ t i).Nonempty} := by
        ext j
        simp only [mem_ofPred_eq, t']
        constructor
        · rintro ⟨y, ⟨⟨x1, hx1, rfl⟩, ⟨x2, hx2, heq⟩⟩⟩
          have h_inj : x1 = x2 := φ.injective heq.symm
          exact ⟨x1, ⟨hx1, h_inj ▸ hx2⟩⟩
        · rintro ⟨x, ⟨hxj, hxi⟩⟩
          exact ⟨φ x, ⟨⟨x, hxj, rfl⟩, ⟨x, hxi, rfl⟩⟩⟩
      rw [h_eq]
      exact ht_sf i
    · -- refinement
      intro b
      obtain ⟨a, ha⟩ := ht_ref b
      refine ⟨a, ?_⟩
      -- t b ⊆ s' a = φ⁻¹' (s a), so φ '' t b ⊆ s a
      have h_sub : t b ⊆ φ ⁻¹' (s a) := ha
      calc t' b = φ '' (t b) := rfl
      _ ⊆ φ '' (φ ⁻¹' (s a)) := image_mono h_sub
      _ ⊆ s a := image_preimage_subset _ _

end PiBase
