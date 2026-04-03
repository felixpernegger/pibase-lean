import PibaseLean.Properties.P43.Defs
import PibaseLean.Properties.P42.Defs

open Topology Set Function

namespace PiBase

/- Theorem 63: a locally injectively path connected space
is locally path connected -/
instance instLocally {X : Type*} [TopologicalSpace X] [h : LocallyInjPathConnectedSpace X] :
    LocPathConnectedSpace X where
  path_connected_basis x := by
    refine Filter.hasBasis_self.mpr ?_
    intro t ht
    #check Filter.hasBasis_self (l := 𝓝 x) (P := fun s ↦ s ∈ 𝓝 x ∧ IsPathConnected s)


end PiBase
