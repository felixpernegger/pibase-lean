module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P146.Defs

@[expose] public section

namespace PiBase

open Topology Filter Set Function TopologicalSpace


section Meta

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.ultraparacompactSpace : WellDefined UltraparacompactSpace :=
  fun {_ _} _ _ hXY h => by
    let φ := hXY.some
    constructor
    intro α s hs_open hs_cover
    let s' : α → Set _ := fun a => φ ⁻¹' (s a)
    have hs'_open : ∀ a, IsOpen (s' a) := fun a => φ.isOpen_preimage.mpr (hs_open a)
    have hs'_cover : (⋃ a, s' a) = univ := by
      rw [← preimage_iUnion, hs_cover, preimage_univ]
    obtain ⟨β, t, ht_open, ht_part, ht_ref⟩ := h.partition_refinement α s' hs'_open hs'_cover
    let t' : β → Set _ := fun b => φ '' (t b)
    refine ⟨β, t', fun b => φ.isOpen_image.mpr (ht_open b), ?_, ?_⟩
    · have h_empty : ∅ ∉ range t' := by
        intro h_mem
        obtain ⟨b, hb⟩ := h_mem
        have : t b = ∅ := by
          have hb' : φ '' (t b) = ∅ := hb
          exact image_eq_empty.mp hb'
        exact ht_part.1 ⟨b, this⟩
      have h_disj : (range t').PairwiseDisjoint id := by
        intro s1 hs1 s2 hs2 hne
        obtain ⟨b1, rfl⟩ := hs1
        obtain ⟨b2, rfl⟩ := hs2
        have h_t_ne : t b1 ≠ t b2 := by
          intro heq
          apply hne
          simp [t', heq]
        have h_disj_orig : Disjoint (t b1) (t b2) := by
          exact ht_part.pairwiseDisjoint ⟨b1, rfl⟩ ⟨b2, rfl⟩ (by intro heq; exact h_t_ne heq)
        exact disjoint_image_of_injective φ.injective h_disj_orig
      have h_exists : ∀ y : _, ∃ s ∈ range t', y ∈ s := by
        intro y
        obtain ⟨x, rfl⟩ := φ.surjective y
        have : x ∈ (⋃₀ range t) := by rw [ht_part.sUnion_eq_univ]; trivial
        obtain ⟨s, hs_mem, hx_mem⟩ := Set.mem_sUnion.mp this
        obtain ⟨b, rfl⟩ := hs_mem
        exact ⟨t' b, ⟨b, rfl⟩, ⟨x, hx_mem, rfl⟩⟩
      exact Set.PairwiseDisjoint.isPartition_of_exists_of_ne_empty h_disj h_exists h_empty
    · intro b
      obtain ⟨a, ha⟩ := ht_ref b
      have h_sub : t' b ⊆ s a := by
        calc t' b = φ '' (t b) := rfl
        _ ⊆ φ '' (φ ⁻¹' (s a)) := image_mono ha
        _ ⊆ s a := image_preimage_subset _ _
      exact ⟨a, h_sub⟩

end Meta

end PiBase
