module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P155.Defs

@[expose] public section

namespace PiBase

open Topology Filter Set Function TopologicalSpace

section Meta


variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.locallyOneEuclideanSpace : WellDefined LocallyOneEuclideanSpace :=
  fun {_ _} _ _ hXY h => by
    let φ := hXY.some
    refine @LocallyOneEuclideanSpace.mk _ _ fun y => ?_
    let x := φ.symm y
    obtain ⟨s, hs_nhds, hs_homeo⟩ := h.locally_homeomorph x
    have h_img_mem : φ '' s ∈ 𝓝 y := by
      have h_eq : y = φ x := by simp [x]
      rw [h_eq, ← φ.map_nhds_eq x, Filter.mem_map, φ.preimage_image]
      exact hs_nhds
    have e1 : s ≃ₜ φ '' s := φ.image s
    obtain ⟨e2⟩ := hs_homeo
    exact ⟨φ '' s, h_img_mem, ⟨e1.symm.trans e2⟩⟩

end Meta

end PiBase
