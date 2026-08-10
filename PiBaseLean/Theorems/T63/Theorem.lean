module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P42.Defs
public import PiBaseLean.Properties.P43.Defs

@[expose] public section

open Topology Set Function

namespace PiBase

/- Theorem 63: a locally injectively path connected space
is locally path connected -/
instance instLocallyPathConnectedSpaceOfLocallyInjPathConnectedSpace
    {X : Type*} [TopologicalSpace X] [h : LocallyInjPathConnectedSpace X] :
    LocallyPathConnectedSpace X where
  path_connected_basis x := by
    apply Filter.hasBasis_self.mpr (fun t ht ↦ ?_)
    have : (𝓝 x).HasBasis (fun s ↦ s ∈ 𝓝 x ∧ IsOpen s ∧ IsInjPathConnected s) id := by
      convert h.inj_path_connected_basis x using 1
      ext s
      simp only [and_congr_left_iff, and_imp]
      intro hs _
      exact IsOpen.mem_nhds_iff hs
    obtain ⟨r, xr, hr, rt⟩ := (Filter.hasBasis_self).1 this t ht
    use r, xr, hr.2.isPathConnected <| nonempty_of_mem <| mem_of_mem_nhds xr

end PiBase

namespace PiBase.Formal

theorem T63 : P43 ≤ P42 := @instLocallyPathConnectedSpaceOfLocallyInjPathConnectedSpace

end PiBase.Formal
