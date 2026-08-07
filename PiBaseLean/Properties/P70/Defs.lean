module

public import PiBaseLean.AdditionalDefs.Games
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

universe u

namespace PiBase

/- 70. Markov Menger -/
class MarkovMengerSpace (X : Type u) [TopologicalSpace X] : Prop where
  markov_menger : HasMarkovKWinningStrategyB (mengerGame X) 1

end PiBase

namespace PiBase.Formal

def P70 : Property where
  toPred := MarkovMengerSpace
  well_defined φ h := sorry

end PiBase.Formal
