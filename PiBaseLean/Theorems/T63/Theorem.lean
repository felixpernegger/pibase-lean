import PiBaseLean.Properties.Bundled.Basic
import PiBaseLean.Properties.P42.Defs
import PiBaseLean.Properties.P43.Defs

open Topology Set Function

namespace PiBase

open PiBase.AdditionalDefs

/- Theorem 63: a locally injectively path connected space
is locally path connected -/
instance instLocallyPathConnectedSpaceOfLocallyInjPathConnectedSpace
    {X : Type*} [TopologicalSpace X] [h : LocallyInjPathConnectedSpace X] :
    LocPathConnectedSpace X where
  path_connected_basis x := by
    apply Filter.hasBasis_self.mpr (fun t ht ↦ ?_)
    obtain ⟨r, xr, hr, rt⟩ := (Filter.hasBasis_self).1 (h.inj_path_connected_basis x) t ht
    use r, xr, hr.isPathConnected <| nonempty_of_mem <| mem_of_mem_nhds xr

end PiBase

namespace PiBase.Formal

theorem T63 : P43 ≤ P42 := @instLocallyPathConnectedSpaceOfLocallyInjPathConnectedSpace

end PiBase.Formal
