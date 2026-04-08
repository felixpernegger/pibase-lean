module

public import Mathlib.Topology.Connected.TotallyDisconnected
public import Mathlib.Topology.Separation.Hausdorff
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

open Topology Set Function Filter TopologicalSpace

universe u

namespace PiBase

/- 195. Stone space -/
class StoneSpace (X : Type u) [TopologicalSpace X] : Prop extends
    CompactSpace X, T2Space X, TotallyDisconnectedSpace X

end PiBase

namespace PiBase.Formal

def P195 : Property where
  toPred := StoneSpace
  well_defined φ h := sorry

end PiBase.Formal
