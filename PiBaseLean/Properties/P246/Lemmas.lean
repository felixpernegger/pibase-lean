module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P246.Defs

@[expose] public section

namespace PiBase

open Topology Filter Set Function TopologicalSpace

section Meta


variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

-- Transport

-- Transport via Homeomorph image: closed preimage via Homeomorph,
-- discrete via subtype homeomorph, open cover via isOpenMap, etc.
theorem WellDefined.collectionwiseHausdorffSpace : WellDefined CollectionwiseHausdorffSpace :=
  fun {_ Y} _ _ hXY hX => by
    let φ := hXY.some
    constructor
    intro v hv_closed hv_discrete
    -- preimage is closed
    have h_closed_pre : IsClosed (φ ⁻¹' v) := φ.isClosed_preimage.mpr hv_closed
    -- preimage = symm image for discrete transport
    have h_pre_eq : φ ⁻¹' v = φ.symm '' v := by
      ext x
      constructor
      · intro hx
        exact ⟨φ x, hx, by simp⟩
      · rintro ⟨y, hy, rfl⟩
        simp [hy]
    have h_discrete_pre : IsDiscrete (φ ⁻¹' v) := by
      rw [h_pre_eq]
      have hDT : DiscreteTopology v := isDiscrete_iff_discreteTopology.mp hv_discrete
      have hDT' : DiscreteTopology (φ.symm '' v) := by
        have := hDT
        exact (φ.symm.image v).discreteTopology
      exact isDiscrete_iff_discreteTopology.mpr hDT'
    obtain ⟨sX, hOpenX, hDisjX, hCoverX, hUniqueX⟩ :=
      hX.collectionwise_hausdorff (φ ⁻¹' v) h_closed_pre h_discrete_pre
    -- push each open set by φ
    let sY : Set (Set Y) := (φ '' ·) '' sX
    refine ⟨sY, ?_, ?_, ?_, ?_⟩
    · -- each image is open
      intro a ha
      obtain ⟨t, ht, rfl⟩ := ha
      exact φ.isOpenMap t (hOpenX t ht)
    · -- pairwise disjoint preserved by injective φ
      intro a ha b hb hne
      obtain ⟨ta, hta, rfl⟩ := ha
      obtain ⟨tb, htb, rfl⟩ := hb
      have hta_ne_tb : ta ≠ tb := by
        intro heq
        exact hne (congrArg (φ '' ·) heq)
      have hDisj : Disjoint ta tb := hDisjX _ hta _ htb hta_ne_tb
      rw [Set.disjoint_iff] at hDisj ⊢
      intro y
      simp only [Set.mem_inter_iff, Set.mem_image] at y ⊢
      rintro ⟨⟨x1, hx1, rfl⟩, x2, hx2, heq⟩
      have hx_eq : x1 = x2 := φ.injective heq.symm
      subst hx_eq
      exact hDisj ⟨hx1, hx2⟩
    · -- cover of v: φ.symm y in preimage, get a ∈ sX, then φ '' a covers y
      intro y hy
      have hy_pre : φ.symm y ∈ φ ⁻¹' v := by
        simp [hy]
      obtain ⟨a, ha_sX, h_mem_a⟩ := hCoverX _ hy_pre
      exact ⟨φ '' a, ⟨a, ha_sX, rfl⟩, ⟨φ.symm y, h_mem_a, by simp⟩⟩
    · -- exists-unique membership under bijection
      intro aY haY
      obtain ⟨t, ht_sX, rfl⟩ := haY
      have hUniq_t : ∃! x ∈ φ ⁻¹' v, x ∈ t := hUniqueX t ht_sX
      obtain ⟨x0, ⟨hx0_pre, hx0_t⟩, hx0_uniq⟩ := hUniq_t
      have hx0_v : φ x0 ∈ v := hx0_pre
      have hx0_image_mem : φ x0 ∈ φ '' t := ⟨x0, hx0_t, rfl⟩
      refine ⟨φ x0, ⟨hx0_v, hx0_image_mem⟩, ?_⟩
      intro y hy
      obtain ⟨hy_v, hy_im⟩ := hy
      obtain ⟨x, hx_t, hx_eq⟩ := hy_im
      have hx_pre : x ∈ φ ⁻¹' v := by
        rw [Set.mem_preimage]
        rw [hx_eq]
        exact hy_v
      have hx_eq_x0 : x = x0 := hx0_uniq _ ⟨hx_pre, hx_t⟩
      rw [← hx_eq, hx_eq_x0]

end Meta

end PiBase
