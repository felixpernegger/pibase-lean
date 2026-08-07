module

public import PiBaseLean.AdditionalDefs.Games
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

universe u

namespace PiBase

open Classical in
/- 206. Strongly Choquet -/
class StronglyChoquetSpace (X : Type u) [TopologicalSpace X] : Prop where
  strongly_choquet (_ : Inhabited X) : HasWinningStrategyB (strongChoquetGame X)

end PiBase

namespace PiBase.Formal

def P206 : Property where
  toPred := StronglyChoquetSpace
  well_defined φ h := sorry

end PiBase.Formal
