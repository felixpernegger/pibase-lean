module

public import PiBaseLean.AdditionalDefs.Games
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

universe u

namespace PiBase

/- 160. Strategically k-Menger -/
class StrategicallyKMengerSpace (X : Type u) [TopologicalSpace X] : Prop where
  strategically_k_menger : HasMarkovKWinningStrategyB (kMengerGame X) 1

end PiBase

namespace PiBase.Formal

def P160 : Property where
  toPred := StrategicallyKMengerSpace
  well_defined φ h := sorry

end PiBase.Formal
