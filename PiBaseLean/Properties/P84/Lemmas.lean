module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P84.Defs

@[expose] public section

namespace PiBase

open Topology Filter Set Function TopologicalSpace

section Meta


variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.locallyT2Space : WellDefined LocallyT2Space :=
  fun {_ _} _ _ hXY h => by
    let φ := hXY.some
    constructor
    intro y
    rcases h.locally_t2 (φ.symm y) with ⟨C, hC_mem, hC_t2⟩
    refine ⟨φ '' C, ?_, ?_⟩
    · have h_pre : φ ⁻¹' (φ '' C) = C := φ.preimage_image C
      have h1 : φ ⁻¹' (φ '' C) ∈ 𝓝 (φ.symm y) := by
        rw [h_pre]
        exact hC_mem
      have h_map : Filter.map φ (𝓝 (φ.symm y)) = 𝓝 (φ (φ.symm y)) := φ.map_nhds_eq (φ.symm y)
      have h2 : φ '' C ∈ Filter.map φ (𝓝 (φ.symm y)) := h1
      have h3 : φ '' C ∈ 𝓝 (φ (φ.symm y)) := h_map ▸ h2
      have h_eq : φ (φ.symm y) = y := φ.apply_symm_apply y
      rwa [h_eq] at h3
    · have : T2Space C := hC_t2
      exact (φ.image C).t2Space

end Meta

end PiBase
