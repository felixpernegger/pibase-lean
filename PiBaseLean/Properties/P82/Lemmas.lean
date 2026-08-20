module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P82.Defs

@[expose] public section

namespace PiBase

open Topology Filter Set Function TopologicalSpace

section Meta


variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.locallyMetrizableSpace : WellDefined LocallyMetrizableSpace :=
  fun {_ _} _ _ hXY h => by
    let φ := hXY.some
    constructor
    intro y
    let x := φ.symm y
    rcases h.locally_metrizable x with ⟨C, hC_mem, hC_met⟩
    have h_img_mem : φ '' C ∈ 𝓝 y := by
      have h_eq : y = φ x := by simp [x]
      rw [h_eq, ← φ.map_nhds_eq x, Filter.mem_map, φ.preimage_image]
      exact hC_mem
    have h_met : MetrizableSpace (φ '' C) := by
      let e : C ≃ₜ φ '' C := φ.image C
      have : MetrizableSpace C := hC_met
      exact e.symm.isEmbedding.metrizableSpace
    exact ⟨φ '' C, h_img_mem, h_met⟩

end Meta

end PiBase
