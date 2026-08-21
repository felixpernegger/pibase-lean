module

public import PiBaseLean.Properties.P157.Defs

@[expose] public section

universe u

namespace PiBase

/- 158. Markov k-Rothberger -/
class MarkovKRothbergerSpace (X : Type u) [TopologicalSpace X] : Prop where
  markov_k_rothberger : HasMarkovKWinningStrategyB (kRothbergerGame X) 1

end PiBase
