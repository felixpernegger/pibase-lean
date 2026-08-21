module

public import PiBaseLean.Properties.P95.Lemmas
public import PiBaseLean.Properties.P96.Defs

@[expose] public section

namespace PiBase

open Topology Set

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.locallyArcConnectedSpace : WellDefined LocallyArcConnectedSpace :=
  fun {_ _} _ _ hXY h => by
    let φ := hXY.some
    constructor
    intro y
    let x := φ.symm y
    have hX := h.arc_connected_basis x
    have h_eq : Filter.map φ (𝓝 x) = 𝓝 y := by
      have hmap := φ.map_nhds_eq x
      have hxy : φ x = y := φ.apply_symm_apply y
      calc Filter.map φ (𝓝 x) = 𝓝 (φ x) := hmap
        _ = 𝓝 y := by rw [hxy]
    have h_basis : (𝓝 y).HasBasis
        (fun s => x ∈ s ∧ IsOpen s ∧ ArcConnectedSpace s) (fun s => φ '' s) := by
      rw [← h_eq]
      exact hX.map φ
    have h_target : (𝓝 y).HasBasis
        (fun t => y ∈ t ∧ IsOpen t ∧ ArcConnectedSpace t) id := by
      apply h_basis.to_hasBasis'
      · intro s hs
        have hy_mem : y ∈ φ '' s := ⟨x, hs.1, φ.apply_symm_apply y⟩
        have h_open : IsOpen (φ '' s) := (φ.isOpen_image).mpr hs.2.1
        have h_arc : ArcConnectedSpace (φ '' s) := by
          let e : s ≃ₜ φ '' s := φ.image s
          have : ArcConnectedSpace s := hs.2.2
          exact Homeomorph.arcConnectedSpace e
        exact ⟨φ '' s, ⟨hy_mem, h_open, h_arc⟩, Subset.rfl⟩
      · intro t ht
        exact IsOpen.mem_nhds ht.2.1 ht.1
    exact h_target

end PiBase
