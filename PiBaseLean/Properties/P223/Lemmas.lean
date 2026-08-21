module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P223.Defs

@[expose] public section

namespace PiBase

open Topology Set

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.locallyContractibleSpace : WellDefined LocallyContractibleSpace :=
  fun {_ _} _ _ hXY h => by
    let φ := hXY.some
    constructor
    intro y
    let x := φ.symm y
    have hX := h.locally_contractible x
    have h_eq : Filter.map φ (𝓝 x) = 𝓝 y := by
      have hmap := φ.map_nhds_eq x
      have hxy : φ x = y := φ.apply_symm_apply y
      calc Filter.map φ (𝓝 x) = 𝓝 (φ x) := hmap
        _ = 𝓝 y := by rw [hxy]
    have h_basis : (𝓝 y).HasBasis
        (fun s => IsOpen s ∧ x ∈ s ∧ ContractibleSpace s) (fun s => φ '' s) := by
      rw [← h_eq]
      exact hX.map φ
    have h_target : (𝓝 y).HasBasis
        (fun t => IsOpen t ∧ y ∈ t ∧ ContractibleSpace t) id := by
      apply h_basis.to_hasBasis'
      · intro s hs
        have hy_mem : y ∈ φ '' s := ⟨x, hs.2.1, φ.apply_symm_apply y⟩
        have h_open : IsOpen (φ '' s) := (φ.isOpen_image).mpr hs.1
        have h_contr : ContractibleSpace (φ '' s) := by
          let e : s ≃ₜ φ '' s := φ.image s
          have : ContractibleSpace s := hs.2.2
          exact e.symm.contractibleSpace
        exact ⟨φ '' s, ⟨h_open, hy_mem, h_contr⟩, Subset.rfl⟩
      · intro t ht
        exact IsOpen.mem_nhds ht.1 ht.2.1
    exact h_target

end PiBase
