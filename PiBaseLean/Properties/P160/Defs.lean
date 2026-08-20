module

public import PiBaseLean.AdditionalDefs.Games
public import PiBaseLean.Properties.P151.Defs

@[expose] public section

universe u v

namespace PiBase

/- 160. Strategically k-Menger -/
class StrategicallyKMengerSpace (X : Type u) [TopologicalSpace X] : Prop where
  strategically_k_menger : HasWinningStrategyB (kMengerGame X)

end PiBase
