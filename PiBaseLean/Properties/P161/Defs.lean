module

public import PiBaseLean.AdditionalDefs.Games
public import PiBaseLean.Properties.P160.Defs

@[expose] public section

universe u

namespace PiBase

/- 161. Markov k-Menger -/
class MarkovKMengerSpace (X : Type u) [TopologicalSpace X] : Prop where
  markov_k_menger : HasMarkovKWinningStrategyB (kMengerGame X) 1

end PiBase
