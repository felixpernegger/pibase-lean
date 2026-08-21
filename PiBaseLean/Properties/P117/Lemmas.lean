module

public import PiBaseLean.Properties.P117.Defs

@[expose] public section

namespace PiBase

open Topology Filter Set

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.hasSigmaLocallyFiniteNetwork : WellDefined HasSigmaLocallyFiniteNetwork :=
  fun {_ _} _ _ hXY h => by
    let φ := hXY.some
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

end PiBase
