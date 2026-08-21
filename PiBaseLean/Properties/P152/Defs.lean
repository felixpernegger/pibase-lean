module

public import PiBaseLean.Properties.P151.Defs

@[expose] public section

universe u

namespace PiBase

/- 152. Markov Rothberger -/
class MarkovRothbergerSpace (X : Type u) [TopologicalSpace X] : Prop where
  markov_rothberger : Nonempty X → HasMarkovKWinningStrategyB (rothbergerGame X) 1

end PiBase
