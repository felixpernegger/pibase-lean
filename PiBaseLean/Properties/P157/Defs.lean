module

public import PiBaseLean.AdditionalDefs.Games
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

universe u

namespace PiBase

/- 157. Strategically k-Rothberger -/
class StrategicallyKRothbergerSpace (X : Type u) [TopologicalSpace X] : Prop where
  strategically_k_rothberger : HasWinningStrategyB (kRothbergerGame X)

end PiBase

namespace PiBase.Formal

def P157 : Property where
  toPred := StrategicallyKRothbergerSpace
  well_defined φ h := sorry

end PiBase.Formal
