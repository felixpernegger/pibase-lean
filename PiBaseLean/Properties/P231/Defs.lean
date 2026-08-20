module

public import Mathlib.AlgebraicTopology.FundamentalGroupoid.SimplyConnected
public import Mathlib.Topology.Homeomorph.Lemmas
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

open Topology Set Function Filter TopologicalSpace

universe u

namespace PiBase

/- 231. Weakly locally simply connected -/
class WeaklyLocallySimplyConnectedSpace (X : Type*) [TopologicalSpace X] : Prop where
  simply_connected_nbhd (x : X) : ∃ U ∈ 𝓝 x, SimplyConnectedSpace U

end PiBase

namespace PiBase.Formal

def P231 : Property where
  toPred := WeaklyLocallySimplyConnectedSpace
  well_defined φ h := by
    refine @WeaklyLocallySimplyConnectedSpace.mk _ _ fun y => ?_
    let x := φ.symm y
    obtain ⟨s, hs_nhds, hs_sc⟩ := h.simply_connected_nbhd x
    have h_img_mem : φ '' s ∈ 𝓝 y := by
      have h_eq : y = φ x := by simp [x]
      rw [h_eq, ← φ.map_nhds_eq x, Filter.mem_map, φ.preimage_image]
      exact hs_nhds
    have h_sc : SimplyConnectedSpace (φ '' s) := by
      let e : s ≃ₜ φ '' s := φ.image s
      have : SimplyConnectedSpace s := hs_sc
      exact e.symm.toHomotopyEquiv.simplyConnectedSpace
    exact ⟨φ '' s, h_img_mem, h_sc⟩

end PiBase.Formal
