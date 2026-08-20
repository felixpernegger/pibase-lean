module

public import Mathlib.Topology.Homeomorph.Lemmas
public import Mathlib.Topology.Separation.Hausdorff
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

open Topology Set Function Filter TopologicalSpace

namespace PiBase

/- 84. Locally T2 -/
class LocallyT2Space (X : Type*) [TopologicalSpace X] : Prop where
  locally_t2 : ∀ (x : X), ∃ C ∈ 𝓝 x, T2Space C

end PiBase

namespace PiBase.Formal

def P84 : Property where
  toPred := LocallyT2Space
  well_defined φ h := by
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

end PiBase.Formal
