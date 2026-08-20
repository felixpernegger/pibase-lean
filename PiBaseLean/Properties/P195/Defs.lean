module

public import Mathlib.Topology.Connected.TotallyDisconnected
public import Mathlib.Topology.Homeomorph.Lemmas
public import Mathlib.Topology.Separation.Hausdorff

@[expose] public section

open Topology Set Function Filter TopologicalSpace

universe u

namespace PiBase

/- 195. Stone space -/
class StoneSpace (X : Type u) [TopologicalSpace X] : Prop extends
    CompactSpace X, T2Space X, TotallyDisconnectedSpace X

end PiBase
