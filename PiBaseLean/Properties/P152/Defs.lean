module

public import PiBaseLean.AdditionalDefs.Games
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

universe u

namespace PiBase

/- 152. Markov Rothberger -/
class MarkovRothbergerSpace (X : Type u) [TopologicalSpace X] : Prop where
  markov_rothberger : HasMarkovKWinningStrategyB (rothbergerGame X) 1

end PiBase

namespace PiBase.Formal

def P152 : Property where
  toPred := MarkovRothbergerSpace
  well_defined φ h := sorry

end PiBase.Formal
