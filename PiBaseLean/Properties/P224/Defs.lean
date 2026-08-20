module

public import Mathlib.Topology.Homotopy.Contractible
public import Mathlib.Topology.Homeomorph.Lemmas
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

open Topology Set Function Filter TopologicalSpace

universe u

namespace PiBase

/- 224. Weakly locally contractible -/
class WeaklyLocallyContractibleSpace (X : Type u) [TopologicalSpace X] : Prop where
  weakly_locally_contractible (x : X) : ∃ s ∈ 𝓝 x, ContractibleSpace s

end PiBase

namespace PiBase.Formal

def P224 : Property where
  toPred := WeaklyLocallyContractibleSpace
  well_defined φ h := by
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

end PiBase.Formal
