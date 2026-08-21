module

public import PiBaseLean.AdditionalDefs.Meta
public import PiBaseLean.Properties.P144.Defs

@[expose] public section

namespace PiBase

open Topology TopologicalSpace

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem WellDefined.locallyPseudoMetrizableSpace : WellDefined LocallyPseudoMetrizableSpace :=
  fun {_ _} _ _ hXY h => by
    let φ := hXY.some
    refine @LocallyPseudoMetrizableSpace.mk _ _ fun y => ?_
    let x := φ.symm y
    obtain ⟨s, hs_nhds, hs_pseudo⟩ := h.nbhd_pseudometrizable x
    have h_img_mem : φ '' s ∈ 𝓝 y := by
      have h_eq : y = φ x := by simp [x]
      rw [h_eq, ← φ.map_nhds_eq x, Filter.mem_map, φ.preimage_image]
      exact hs_nhds
    have h_pseudo : PseudoMetrizableSpace (φ '' s) := by
      let e : s ≃ₜ φ '' s := φ.image s
      have : PseudoMetrizableSpace s := hs_pseudo
      exact e.symm.isInducing.pseudoMetrizableSpace
    exact ⟨φ '' s, h_img_mem, h_pseudo⟩

end PiBase
