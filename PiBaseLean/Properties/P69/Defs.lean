module

public import PiBaseLean.AdditionalDefs.Games
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

universe u

namespace PiBase

/- 69. Strategic Menger -/
class StrategicMengerSpace (X : Type u) [TopologicalSpace X] : Prop where
  strategic_menger : HasWinningStrategyB (mengerGame X)

end PiBase

namespace PiBase.Formal

def P69 : Property where
  toPred := StrategicMengerSpace
  well_defined φ h := sorry

end PiBase.Formal
