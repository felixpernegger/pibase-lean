module

public import PiBaseLean.AdditionalDefs.Constructions
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

open Topology Set Function

namespace PiBase

open PiBase.AdditionalDefs

/- 204. Has a cut point -/
class HasACutPoint (X : Type*)
    [TopologicalSpace X] extends ConnectedSpace X where
  ex_cut : ∃ p : X, IsCutPoint p

end PiBase

namespace PiBase.Formal

def P204 : Property where
  toPred := HasACutPoint
  well_defined φ h := sorry

end PiBase.Formal
