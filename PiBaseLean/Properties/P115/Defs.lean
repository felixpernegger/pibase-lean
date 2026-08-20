module

public import PiBaseLean.AdditionalDefs.Cover
public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

open Topology Set Function Filter TopologicalSpace

universe u

namespace PiBase

/- 115. Subparacompact -/
class SubparacompactSpace (X : Type u) [TopologicalSpace X] : Prop where
  locallyFinite_refinement :
    ∀ (α : Type u) (s : α → Set X), (∀ a, IsOpen (s a)) → (⋃ a, s a = univ) →
      ∃ (β : Type u) (t : β → Set X),
        (∀ b, IsClosed (t b)) ∧ (⋃ b, t b = univ) ∧ Sigma LocallyFinite t ∧ ∀ b, ∃ a, t b ⊆ s a

end PiBase

namespace PiBase.Formal

def P115 : Property where
  toPred := SubparacompactSpace
  well_defined {X Y : Type u} [TopologicalSpace X] [TopologicalSpace Y] (φ : X ≃ₜ Y) h := by
    constructor
    intro α s hOpen hCover
    let sX : α → Set X := fun a => φ ⁻¹' s a
    have hOpenX : ∀ a, IsOpen (sX a) := fun a => (hOpen a).preimage φ.continuous
    have hCoverX : (⋃ a, sX a) = univ := by
      have : (⋃ a, sX a) = φ ⁻¹' (⋃ a, s a) := by rw [preimage_iUnion]
      rw [this, hCover, preimage_univ]
    obtain ⟨β, t, htClosed, htCover, ⟨ω, r, hCount, hUniv, hLF⟩, htRef⟩ :=
      h.locallyFinite_refinement α sX hOpenX hCoverX
    refine ⟨β, fun b => φ '' t b, ?_, ?_, ?_, ?_⟩
    · intro b; exact φ.isClosedMap _ (htClosed b)
    · calc (⋃ b, φ '' t b : Set Y) = φ '' (⋃ b, t b) := by rw [image_iUnion]
        _ = φ '' univ := by rw [htCover]
        _ = univ := image_univ_of_surjective φ.surjective
    · refine ⟨ω, r, hCount, hUniv, ?_⟩
      intro w y
      obtain ⟨u, hu_mem, hu_fin⟩ := hLF w (φ.symm y)
      have hu_nhds_y : φ '' u ∈ 𝓝 y := by
        have heq : y = φ (φ.symm y) := (φ.apply_symm_apply y).symm
        rw [heq, ← φ.map_nhds_eq (φ.symm y), mem_map, φ.preimage_image]
        exact hu_mem
      refine ⟨φ '' u, hu_nhds_y, ?_⟩
      have heq : {b : r w | (φ '' t b.val ∩ φ '' u).Nonempty} =
          {b : r w | (t b.val ∩ u).Nonempty} := by
        ext b
        simp only [mem_ofPred_eq, Set.Nonempty, mem_inter_iff, mem_image]
        constructor
        · rintro ⟨z, ⟨x1, hx1, rfl⟩, x2, hx2, h_eq⟩
          exact ⟨x1, hx1, (φ.injective h_eq) ▸ hx2⟩
        · rintro ⟨x, hxt, hxu⟩
          exact ⟨φ x, ⟨x, hxt, rfl⟩, x, hxu, rfl⟩
      rw [heq]
      exact hu_fin
    · intro b
      obtain ⟨a, ha⟩ := htRef b
      exact ⟨a, fun y hy => by
        obtain ⟨x, hxt, rfl⟩ := hy
        exact ha hxt⟩

end PiBase.Formal
