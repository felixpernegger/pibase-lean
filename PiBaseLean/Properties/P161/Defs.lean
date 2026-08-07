module

public import PiBaseLean.AdditionalDefs.Games
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

universe u

namespace PiBase

/- 161. Markov k-Menger -/
class MarkovKMengerSpace (X : Type u) [TopologicalSpace X] : Prop where
  markov_k_menger : HasMarkovKWinningStrategyB (kMengerGame X) 1

end PiBase

namespace PiBase.Formal

def P161 : Property where
  toPred := MarkovKMengerSpace
  well_defined φ h := sorry

end PiBase.Formal
