module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P224.Defs

@[expose] public section

namespace PiBase

open Topology Filter Set Function TopologicalSpace

section Meta


variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.weaklyLocallyContractibleSpace : WellDefined WeaklyLocallyContractibleSpace :=
  fun {_ _} _ _ hXY h => by
    let φ := hXY.some
    refine @WeaklyLocallyContractibleSpace.mk _ _ fun y => ?_
    let x := φ.symm y
    obtain ⟨s, hs_nhds, hs_contr⟩ := h.weakly_locally_contractible x
    have h_img_mem : φ '' s ∈ 𝓝 y := by
      have h_eq : y = φ x := by simp [x]
      rw [h_eq, ← φ.map_nhds_eq x, Filter.mem_map, φ.preimage_image]
      exact hs_nhds
    have h_contr : ContractibleSpace (φ '' s) := by
      let e : s ≃ₜ φ '' s := φ.image s
      have : ContractibleSpace s := hs_contr
      exact e.symm.contractibleSpace
    exact ⟨φ '' s, h_img_mem, h_contr⟩

end Meta

end PiBase

