module

public import PiBaseLean.AdditionalDefs.Games
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

universe u

namespace PiBase

/- 158. Markov k-Rothberger -/
class MarkovKRothbergerSpace (X : Type u) [TopologicalSpace X] : Prop where
  markov_k_rothberger : HasMarkovKWinningStrategyB (kRothbergerGame X) 1

end PiBase

namespace PiBase.Formal

def P158 : Property where
  toPred := MarkovKRothbergerSpace
  well_defined φ h := sorry

end PiBase.Formal
