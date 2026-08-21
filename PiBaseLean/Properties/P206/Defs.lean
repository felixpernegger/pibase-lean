module

public import PiBaseLean.AdditionalDefs.Games

@[expose] public section

universe u

namespace PiBase

/- 206. Strongly Choquet -/
class StronglyChoquetSpace (X : Type u) [TopologicalSpace X] : Prop where
  strongly_choquet (_ : Inhabited X) : HasWinningStrategyB (strongChoquetGame X)

end PiBase
