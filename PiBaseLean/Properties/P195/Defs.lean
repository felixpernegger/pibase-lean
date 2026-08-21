module

public import Mathlib.Topology.Homeomorph.Lemmas

@[expose] public section

universe u

namespace PiBase

/- 195. Stone space -/
class StoneSpace (X : Type u) [TopologicalSpace X] : Prop extends
    CompactSpace X, T2Space X, TotallyDisconnectedSpace X

end PiBase
