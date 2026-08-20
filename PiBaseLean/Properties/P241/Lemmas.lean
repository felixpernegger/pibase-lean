module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P241.Defs

@[expose] public section

namespace PiBase

open Topology Filter Set Function TopologicalSpace

open Topology

section Meta


variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.locallyEuclideanHalfLine : WellDefined LocallyEuclideanHalfLine :=
  fun {_ _} _ _ hXY h => by
    let φ := hXY.some
    refine @LocallyEuclideanHalfLine.mk _ _ fun y => ?_
    let x := φ.symm y
    obtain ⟨s, hs, f, hf⟩ := h.locally_homeomorph x
    have h_img_mem : φ '' s ∈ 𝓝 y := by
      have hy : y = φ x := by simp [x]
      rw [hy, ← φ.map_nhds_eq x, Filter.mem_map, φ.preimage_image]
      exact hs
    have e : s ≃ₜ φ '' s := φ.image s
    exact ⟨φ '' s, h_img_mem, f ∘ e.symm, hf.comp e.symm.isOpenEmbedding⟩

end Meta

end PiBase
