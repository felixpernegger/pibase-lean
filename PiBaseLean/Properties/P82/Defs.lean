module

public import Mathlib.Topology.Metrizable.Basic
public import Mathlib.Topology.Homeomorph.Lemmas
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

open Topology Set Function Filter TopologicalSpace

namespace PiBase

/- 82. Locally metrizable -/
class LocallyMetrizableSpace (X : Type*) [TopologicalSpace X] : Prop where
  locally_metrizable : ∀ (x : X), ∃ C ∈ 𝓝 x, MetrizableSpace C

end PiBase

namespace PiBase.Formal

def P82 : Property where
  toPred := LocallyMetrizableSpace
  well_defined φ h := by
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

end PiBase.Formal
