module

public import PiBaseLean.AdditionalDefs.Games
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

universe u

namespace PiBase

/- 151. Strategically Rothberger -/
class StrategicallyRothbergerSpace (X : Type u) [TopologicalSpace X] : Prop where
  strategically_rothberger : Nonempty X → HasWinningStrategyB (rothbergerGame X)

end PiBase

namespace PiBase.Formal

def P151 : Property where
  toPred := StrategicallyRothbergerSpace
  well_defined φ h := sorry

end PiBase.Formal
