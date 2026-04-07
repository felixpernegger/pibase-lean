import Mathlib.Topology.Connected.Basic
import PiBaseLean.Properties.Bundled.Defs

open Topology Set Function

namespace PiBase

/- 196. Hereditarily connected -/
class HereditarilyConnected (X : Type*) [TopologicalSpace X] : Prop where
  subset_connected (s : Set X) : IsPreconnected s

end PiBase

namespace PiBase.Formal

def P196 : Property where
  toPred := HereditarilyConnected
  well_defined φ h := sorry

end PiBase.Formal
