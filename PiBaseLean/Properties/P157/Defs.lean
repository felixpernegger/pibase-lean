module

public import PiBaseLean.Properties.P151.Defs

@[expose] public section

universe u v

namespace PiBase

/- 157. Strategically k-Rothberger -/
class StrategicallyKRothbergerSpace (X : Type u) [TopologicalSpace X] : Prop where
  strategically_k_rothberger : HasWinningStrategyB (kRothbergerGame X)

end PiBase
