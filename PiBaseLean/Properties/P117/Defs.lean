module

public import PiBaseLean.AdditionalDefs.Cover
public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

open Topology Set Function Filter TopologicalSpace

universe u

namespace PiBase

/- 117. Has a σ-locally finite network -/
class HasSigmaLocallyFiniteNetwork (X : Type u) [TopologicalSpace X] : Prop where
  ex_network : ∃ (ι : Type u) (f : ι → Set X), Sigma LocallyFinite f ∧ IsNetwork f

end PiBase

namespace PiBase.Formal

def P117 : Property where
  toPred := HasSigmaLocallyFiniteNetwork
  well_defined {X Y : Type u} [TopologicalSpace X] [TopologicalSpace Y] (φ : X ≃ₜ Y) h := by
    obtain ⟨ι, f, ⟨ω, r, hCount, hUniv, hLF⟩, hNet⟩ := h.ex_network
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
        · rintro ⟨z, ⟨x1, hx1, rfl⟩, x2, hx2, hφ⟩
          have hx : x2 = x1 := φ.injective hφ
          exact ⟨x1, hx1, hx ▸ hx2⟩
        · rintro ⟨x, hxf, hxu⟩
          exact ⟨φ x, ⟨x, hxf, rfl⟩, x, hxu, rfl⟩
      rw [heq]; exact hu_fin
    · intro x s hs
      have hs' : s ∈ 𝓝 (φ (φ.symm x)) := by
        simpa using hs
      have hsX : φ ⁻¹' s ∈ 𝓝 (φ.symm x) :=
        φ.continuous.continuousAt hs'
      obtain ⟨i, hxi, hsub⟩ := hNet (φ.symm x) (φ ⁻¹' s) hsX
      refine ⟨i, ?_, ?_⟩
      · simpa using mem_image_of_mem φ hxi
      · intro y hy
        obtain ⟨z, hz, rfl⟩ := hy
        have : z ∈ φ ⁻¹' s := hsub hz
        exact this

end PiBase.Formal
