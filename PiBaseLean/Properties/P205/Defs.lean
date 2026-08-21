module

public import PiBaseLean.AdditionalDefs.Constructions

@[expose] public section

namespace PiBase

/- 205. Cut point space -/
class CutPointSpace (X : Type*)
    [TopologicalSpace X] extends ConnectedSpace X where
  all_cut (p : X) : IsCutPoint p

end PiBase
