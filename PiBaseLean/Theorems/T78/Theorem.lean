module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P36.Defs
public import PiBaseLean.Properties.P44.Defs

@[expose] public section

open Topology Set Function

namespace PiBase

/- Theorem 78: a biconnected space is connected -/
theorem instBiconnectedSpaceOfPreconnectedSpace
    {X : Type*} [TopologicalSpace X] [BiconnectedSpace X] :
    PreconnectedSpace X := by infer_instance

end PiBase

namespace PiBase.Formal

theorem T78 : P44 ≤ P36 := @instBiconnectedSpaceOfPreconnectedSpace

end PiBase.Formal
