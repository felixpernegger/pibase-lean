module

public import PiBaseLean.AdditionalDefs.Games
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

universe u

namespace PiBase

/- 187. W-space -/
class WSpace (X : Type u) [TopologicalSpace X] : Prop where
  w_space (x : X) : HasWinningStrategyA (wGame x)

end PiBase

namespace PiBase.Formal

def P187 : Property where
  toPred := WSpace
  well_defined φ h := sorry

end PiBase.Formal
