module

public import PiBaseLean.Bundled.Basic
public import PiBaseLean.Properties.P204.Bundled
public import PiBaseLean.Properties.P36.Bundled

@[expose] public section

universe u

namespace PiBase

/-- Theorem T452: P204 (HasACutPoint) => P36 (PreconnectedSpace) -/
theorem instPreconnectedSpaceOfHasACutPoint {X : Type u}
    [TopologicalSpace X] [HasACutPoint X] :
    PreconnectedSpace X := by infer_instance

end PiBase

namespace PiBase.Formal

theorem T452 : P204 ≤ P36 := fun X _ ↦ @instPreconnectedSpaceOfHasACutPoint X _

end PiBase.Formal
