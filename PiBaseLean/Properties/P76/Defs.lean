module

public import PiBaseLean.AdditionalDefs.Games
public import PiBaseLean.Properties.Bundled.Defs
public import Mathlib.Topology.UniformSpace.Uniformizable

@[expose] public section

universe u

namespace PiBase

/- 76. Proximal -/
class ProximalSpace (X : Type u) [TopologicalSpace X] : Prop extends CompletelyRegularSpace X where
  proximal (h : Inhabited X):
    letI t := (CompletelyRegularSpace.exists_uniformSpace (X := X)).choose
    HasWinningStrategyA (@proximalGame X t h)

end PiBase

namespace PiBase.Formal

def P76 : Property where
  toPred := ProximalSpace
  well_defined φ h := sorry

end PiBase.Formal
