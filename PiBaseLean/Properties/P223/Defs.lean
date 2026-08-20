module

public import Mathlib.Order.Filter.Bases.Basic
public import Mathlib.Topology.Defs.Filter
public import Mathlib.Topology.Homeomorph.Lemmas
public import Mathlib.Topology.Homotopy.Contractible
public import PiBaseLean.Properties.Bundled.Defs
public import PiBaseLean.Properties.P199.Defs

@[expose] public section

open Topology Set Function Filter

universe u

namespace PiBase

/- 223. Locally contractible -/
class LocallyContractibleSpace (X : Type u) [TopologicalSpace X] : Prop where
  locally_contractible (x : X) : (𝓝 x).HasBasis
    (fun (s : Set X) ↦ IsOpen s ∧ x ∈ s ∧ ContractibleSpace s) id

end PiBase

namespace PiBase.Formal

def P223 : Property where
  toPred := LocallyContractibleSpace
  well_defined φ h := by
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

end PiBase.Formal
