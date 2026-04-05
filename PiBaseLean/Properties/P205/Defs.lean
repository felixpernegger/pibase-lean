import PiBaseLean.AdditionalDefs

open Topology Set Function

namespace PiBase

open PiBase.AdditionalDefs

/- 205. Cut point space -/
class CutPointSpace (X : Type*)
    [TopologicalSpace X] extends ConnectedSpace X where
  all_cut (p : X) : IsCutPoint p

end PiBase
