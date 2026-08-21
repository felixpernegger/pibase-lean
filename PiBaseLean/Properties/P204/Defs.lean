module

public import PiBaseLean.AdditionalDefs.Constructions

@[expose] public section

namespace PiBase

/- 204. Has a cut point -/
class HasACutPoint (X : Type*)
    [TopologicalSpace X] extends ConnectedSpace X where
  ex_cut : ∃ p : X, IsCutPoint p

end PiBase
