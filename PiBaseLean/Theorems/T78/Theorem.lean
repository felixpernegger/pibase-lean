module

public import PiBaseLean.Bundled.Basic
public import PiBaseLean.Properties.P36.Bundled
public import PiBaseLean.Properties.P44.Bundled

@[expose] public section

namespace PiBase

/- Theorem 78: a biconnected space is connected -/
theorem instBiconnectedSpaceOfPreconnectedSpace
    {X : Type*} [TopologicalSpace X] [BiconnectedSpace X] :
    PreconnectedSpace X := by infer_instance

end PiBase

namespace PiBase.Formal

theorem T78 : P44 ≤ P36 := @instBiconnectedSpaceOfPreconnectedSpace

end PiBase.Formal
