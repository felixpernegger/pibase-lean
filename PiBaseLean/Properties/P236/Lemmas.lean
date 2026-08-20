module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P236.Defs

@[expose] public section

namespace PiBase

open Topology Filter Set Function TopologicalSpace

open Topology

section Meta


variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.locallyNEuclideanHalfSpace : WellDefined LocallyNEuclideanHalfSpace :=
  fun {_ _} _ _ hXY h => by
    let φ := hXY.some
    obtain ⟨n, hn⟩ := h.locally_homeomorph
    refine @LocallyNEuclideanHalfSpace.mk _ _ ⟨n, fun y => ?_⟩
    let x := φ.symm y
    obtain ⟨U, hU, f, hf⟩ := hn x
    have h_img_mem : φ '' U ∈ 𝓝 y := by
      have hy : y = φ x := by simp [x]
      rw [hy, ← φ.map_nhds_eq x, Filter.mem_map, φ.preimage_image]
      exact hU
    have e : U ≃ₜ φ '' U := φ.image U
    exact ⟨φ '' U, h_img_mem, f ∘ e.symm, hf.comp e.symm.isOpenEmbedding⟩

end Meta

end PiBase
