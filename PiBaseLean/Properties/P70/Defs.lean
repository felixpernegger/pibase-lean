module

public import PiBaseLean.Properties.P69.Defs

@[expose] public section

universe u

namespace PiBase

/- 70. Markov Menger -/
class MarkovMengerSpace (X : Type u) [TopologicalSpace X] : Prop where
  markov_menger : HasMarkovKWinningStrategyB (mengerGame X) 1

end PiBase
