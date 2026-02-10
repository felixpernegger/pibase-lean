import Mathlib
import PibaseLean.Properties.P43.Defs
import PibaseLean.Properties.P42.Defs

open Topology Set Function

namespace PiBase

/- Theorem 63, Locally injectively path connected
implies Locally path connected -/
instance LocallyInjPathConnectedSpace.LocallyPathConnectedSpace
    (X : Type u) [TopologicalSpace X] [h : LocallyInjPathConnectedSpace X] :
    InjPathConnectedSpace X where
  nonempty := h.1
  joined := by


end PiBase
