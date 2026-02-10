import Mathlib
import PibaseLean.Properties.P38.Defs

open Topology Set Function

namespace PiBase

/- Theorem 63, Locally injectively path connected
implies injective path connected -/
instance LocallyInjPathConnectedSpace.InjPathConnectedSpace (X : Type u) [TopologicalSpace X] [LocallyInjPathConnectedSpace X] : InjPathConnectedSpace X :=?

end PiBase
