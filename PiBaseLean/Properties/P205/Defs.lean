module

public import PiBaseLean.AdditionalDefs.Constructions
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

open Topology Set Function

namespace PiBase



/- 205. Cut point space -/
class CutPointSpace (X : Type*)
    [TopologicalSpace X] extends ConnectedSpace X where
  all_cut (p : X) : IsCutPoint p

end PiBase

namespace PiBase.Formal

def P205 : Property where
  toPred := CutPointSpace
  well_defined φ h := sorry

end PiBase.Formal
