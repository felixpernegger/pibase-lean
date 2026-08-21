module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P33.Defs

@[expose] public section

namespace PiBase

open Set

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.countablyMetacompactSpace : WellDefined CountablyMetacompactSpace :=
  fun {X Y} _ _ hXY h => by
    let φ := hXY.some
    constructor
    intro α s hOpen hCover hCount
    let sX : α → Set X := fun a => φ ⁻¹' s a
    have hOpenX : ∀ a, IsOpen (sX a) := fun a => (hOpen a).preimage φ.continuous
    have hCoverX : (⋃ a, sX a = univ) := by
      have : (⋃ a, sX a) = φ ⁻¹' (⋃ a, s a) := by rw [Set.preimage_iUnion]
      rw [this, hCover, Set.preimage_univ]
    obtain ⟨β, t, htOpen, htCover, htPtFin, htRefine⟩ :=
      h.countably_metacompact α sX hOpenX hCoverX hCount
    refine ⟨β, fun b => φ '' t b, ?_, ?_, ?_, ?_⟩
    · intro b; exact φ.isOpen_image.mpr (htOpen b)
    · calc (⋃ b, φ '' t b : Set Y) = φ '' (⋃ b, t b) := by rw [Set.image_iUnion]
        _ = φ '' univ := by rw [htCover]
        _ = univ := Set.image_univ_of_surjective φ.surjective
    · intro y
      have heq : {b | y ∈ φ '' t b} = {b | φ.symm y ∈ t b} := by
        ext b
        simp only [Set.mem_ofPred_eq]
        constructor
        · rintro ⟨x, hx_mem, hx_eq⟩
          have : x = φ.symm y := φ.injective (by rw [hx_eq, φ.apply_symm_apply y])
          rw [this] at hx_mem; exact hx_mem
        · intro hy; exact ⟨φ.symm y, hy, φ.apply_symm_apply y⟩
      rw [heq]; exact htPtFin (φ.symm y)
    · intro b
      obtain ⟨a, ha⟩ := htRefine b
      refine ⟨a, ?_⟩
      intro y hy
      obtain ⟨x, hxt, rfl⟩ := hy
      exact ha hxt

end PiBase
