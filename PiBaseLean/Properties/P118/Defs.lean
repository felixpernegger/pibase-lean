module

public import PiBaseLean.AdditionalDefs.Cover
public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

open Topology Set Function Filter TopologicalSpace

universe u

namespace PiBase

/- 118. Has a σ-locally finite k-network -/
class HasSigmaLocallyFiniteKNetwork (X : Type u) [TopologicalSpace X] : Prop where
  ex_network : ∃ (ι : Type u) (f : ι → Set X), Sigma LocallyFinite f ∧ IsKNetwork f

end PiBase

namespace PiBase.Formal

def P118 : Property where
  toPred := HasSigmaLocallyFiniteKNetwork
  well_defined {X Y : Type u} [TopologicalSpace X] [TopologicalSpace Y] (φ : X ≃ₜ Y) h := by
    obtain ⟨ι, f, ⟨ω, r, hCount, hUniv, hLF⟩, hKNet⟩ := h.ex_network
    refine ⟨⟨ι, fun i => φ '' f i, ?_, ?_⟩⟩
    · refine ⟨ω, r, hCount, hUniv, ?_⟩
      intro w y
      obtain ⟨u, hu_mem, hu_fin⟩ := hLF w (φ.symm y)
      have hu_nhds_y : φ '' u ∈ 𝓝 y := by
        have heq : y = φ (φ.symm y) := (φ.apply_symm_apply y).symm
        rw [heq, ← φ.map_nhds_eq (φ.symm y), mem_map, φ.preimage_image]
        exact hu_mem
      refine ⟨φ '' u, hu_nhds_y, ?_⟩
      have heq : {b : r w | (φ '' f b.val ∩ φ '' u).Nonempty} =
          {b : r w | (f b.val ∩ u).Nonempty} := by
        ext b
        simp only [Set.Nonempty, mem_inter_iff, mem_image, mem_ofPred_eq]
        constructor
        · rintro ⟨z, ⟨x1, hx1, rfl⟩, x2, hx2, hx⟩
          have : x2 = x1 := φ.injective hx
          exact ⟨x1, hx1, this ▸ hx2⟩
        · rintro ⟨x, hxf, hxu⟩
          exact ⟨φ x, ⟨x, hxf, rfl⟩, x, hxu, rfl⟩
      rw [heq]; exact hu_fin
    · intro U K hUOpen hKComp hKU
      have hUOpenX : IsOpen (φ ⁻¹' U) := hUOpen.preimage φ.continuous
      have hKCompX : IsCompact (φ ⁻¹' K) := by
        have : φ ⁻¹' K = φ.symm '' K := by
          ext x
          constructor
          · intro hx
            exact ⟨φ x, hx, φ.symm_apply_apply x⟩
          · rintro ⟨y, hy, rfl⟩
            simp [hy]
        rw [this]
        exact hKComp.image φ.symm.continuous
      have hKUX : φ ⁻¹' K ⊆ φ ⁻¹' U := preimage_mono hKU
      obtain ⟨s, hsSub, hsUniv⟩ := hKNet _ _ hUOpenX hKCompX hKUX
      refine ⟨s, ?_, ?_⟩
      · calc K ⊆ φ '' (φ ⁻¹' K) := by
              intro y hy
              exact ⟨φ.symm y, by simpa [φ.apply_symm_apply] using hy, φ.apply_symm_apply y⟩
          _ ⊆ φ '' (⋃ i ∈ s, f i) := by exact image_mono hsSub
          _ = ⋃ i ∈ s, φ '' f i := by rw [image_iUnion₂]
      · calc (⋃ i ∈ s, φ '' f i : Set Y) = φ '' (⋃ i ∈ s, f i) := by rw [image_iUnion₂]
          _ ⊆ φ '' (φ ⁻¹' U) := by exact image_mono hsUniv
          _ ⊆ U := by exact image_preimage_subset φ _

end PiBase.Formal
