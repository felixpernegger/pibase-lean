module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P105.Defs

@[expose] public section

namespace PiBase

open Topology Filter Set Function TopologicalSpace

section Meta

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.paraLindelofSpace : WellDefined ParaLindelofSpace :=
  fun {X Y} _ _ hXY h => by
    let φ := hXY.some
    constructor
    intro α s hOpen hCover
    let sX : α → Set X := fun a => φ ⁻¹' s a
    have hOpenX : ∀ a, IsOpen (sX a) := fun a => (hOpen a).preimage φ.continuous
    have hCoverX : (⋃ a, sX a) = univ := by
      have : (⋃ a, sX a) = φ ⁻¹' (⋃ a, s a) := by rw [preimage_iUnion]
      rw [this, hCover, preimage_univ]
    obtain ⟨β, t, htOpen, htCover, htLC, htRef⟩ := h.para_lindelof α sX hOpenX hCoverX
    refine ⟨β, fun b => φ '' t b, ?_, ?_, ?_, ?_⟩
    · intro b; exact φ.isOpenMap _ (htOpen b)
    · calc (⋃ b, φ '' t b : Set Y) = φ '' (⋃ b, t b) := by rw [image_iUnion]
        _ = φ '' univ := by rw [htCover]
        _ = univ := image_univ_of_surjective φ.surjective
    · intro y
      obtain ⟨u, hu_mem, hu_count⟩ := htLC (φ.symm y)
      have hu_nhds_y : φ '' u ∈ 𝓝 y := by
        have heq : y = φ (φ.symm y) := (φ.apply_symm_apply y).symm
        rw [heq, ← φ.map_nhds_eq (φ.symm y), mem_map, φ.preimage_image]
        exact hu_mem
      refine ⟨φ '' u, hu_nhds_y, ?_⟩
      have heq : {b | (φ '' t b ∩ φ '' u).Nonempty} = {b | (t b ∩ u).Nonempty} := by
        ext b
        constructor
        · rintro ⟨z, ⟨x1, hx1, rfl⟩, x2, hx2, h_eq⟩
          have h_eq' : φ x2 = φ x1 := h_eq
          have h_inj : x2 = x1 := φ.injective h_eq'
          exact ⟨x1, hx1, h_inj ▸ hx2⟩
        · rintro ⟨x, hxt, hxu⟩
          exact ⟨φ x, ⟨x, hxt, rfl⟩, x, hxu, rfl⟩
      rw [heq]
      exact hu_count
    · intro b
      obtain ⟨a, ha⟩ := htRef b
      exact ⟨a, fun y hy => by
        obtain ⟨x, hxt, rfl⟩ := hy
        exact ha hxt⟩

end Meta

end PiBase
