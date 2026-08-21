module

public import PiBaseLean.Properties.P69.Defs

@[expose] public section

universe u

namespace PiBase

/- 72. 2-Markov Menger -/
class TwoMarkovMengerSpace (X : Type u) [TopologicalSpace X] : Prop where
  two_markov_menger : HasMarkovKWinningStrategyB (mengerGame X) 2

end PiBase
