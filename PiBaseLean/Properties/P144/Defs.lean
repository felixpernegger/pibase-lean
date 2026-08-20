module

public import Mathlib.Topology.Metrizable.Basic
public import Mathlib.Topology.Homeomorph.Lemmas
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

open Topology Set Function Filter TopologicalSpace

universe u

namespace PiBase

/- 144. Locally pseudometrizable -/
class LocallyPseudoMetrizableSpace (X : Type u) [TopologicalSpace X] : Prop where
  nbhd_pseudometrizable (x : X) : ∃ s ∈ 𝓝 x, PseudoMetrizableSpace s

end PiBase

namespace PiBase.Formal

def P144 : Property where
  toPred := LocallyPseudoMetrizableSpace
  well_defined φ h := by
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

end PiBase.Formal
