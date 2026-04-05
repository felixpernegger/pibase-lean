import PiBaseLean.AdditionalDefs

open Topology Set Function

namespace PiBase

open PiBase.AdditionalDefs

/- 204. Has a cut point -/
class HasACutPoint (X : Type*)
    [TopologicalSpace X] extends ConnectedSpace X where
  ex_cut : ∃ p : X, IsCutPoint p

end PiBase
