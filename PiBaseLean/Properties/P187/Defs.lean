module

public import PiBaseLean.AdditionalDefs.Games

@[expose] public section

open Set Filter Topology

universe u v

namespace PiBase

/- 187. W-space -/
class WSpace (X : Type u) [TopologicalSpace X] : Prop where
  w_space (x : X) : HasWinningStrategyA (wGame x)

end PiBase
