import Mathlib.Topology.Connected.PathConnected

open Topology Set Function

namespace PiBase

/- 37. Path connected
Note: Unlike Mathlib, we allow the space to be empty. -/
class PrePathConnectedSpace (X : Type u) [TopologicalSpace X] : Prop where
  joined : ∀ x y : X, Joined x y

end PiBase
