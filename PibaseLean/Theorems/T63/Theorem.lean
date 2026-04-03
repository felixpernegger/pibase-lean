import PibaseLean.Properties.P43.Defs
import PibaseLean.Properties.P42.Defs

open Topology Set Function

namespace PiBase

open PiBase.AdditionalDefs

#check IsInjPathConnected.IsPathConnected

/- Theorem 63: a locally injectively path connected space
is locally path connected -/
instance instLocally {X : Type*} [TopologicalSpace X] [h : LocallyInjPathConnectedSpace X] :
    LocPathConnectedSpace X where
  path_connected_basis x := by
    apply Filter.hasBasis_self.mpr (fun t ht ↦ ?_)
    obtain ⟨r, xr, hr, rt⟩ := (Filter.hasBasis_self).1 (h.inj_path_connected_basis x) t ht
    have : r.Nonempty := by sorry
    use r, xr, (IsInjPathConnected.IsPathConnected)
    sorry


end PiBase
