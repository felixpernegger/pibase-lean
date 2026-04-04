import PibaseLean.Properties.P44.Defs

open Topology Set Function

namespace PiBase

/- Theorem 78: a biconnected space is connected -/
theorem instBiconnectedSpaceOfPreconnectedSpace
    {X : Type*} [TopologicalSpace X] [BiconnectedSpace X] :
    PreconnectedSpace X := by infer_instance

end PiBase
