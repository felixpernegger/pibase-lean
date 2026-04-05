import Mathlib.Topology.Connected.Basic

open Topology Set Function

namespace PiBase

/- 196. Hereditarily connected -/
class HereditarilyConnected (X : Type*) [TopologicalSpace X] : Prop where
  subset_connected (s : Set X) : IsPreconnected s

end PiBase
