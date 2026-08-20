module

public import PiBaseLean.AdditionalDefs.Games

@[expose] public section

universe u v

namespace PiBase

/- 69. Strategic Menger -/
class StrategicMengerSpace (X : Type u) [TopologicalSpace X] : Prop where
  strategic_menger : HasWinningStrategyB (mengerGame X)

end PiBase
