module

public import PiBaseLean.AdditionalDefs.Games

@[expose] public section

universe u v

namespace PiBase

/- 151. Strategically Rothberger -/
class StrategicallyRothbergerSpace (X : Type u) [TopologicalSpace X] : Prop where
  strategically_rothberger : Nonempty X → HasWinningStrategyB (rothbergerGame X)

end PiBase
