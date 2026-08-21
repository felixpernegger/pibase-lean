module

public import PiBaseLean.Bundled.Basic
public import PiBaseLean.Properties.P189.Bundled
public import PiBaseLean.Properties.P36.Bundled

@[expose] public section

universe u

namespace PiBase

/-- Theorem T484: P189 (SigmaConnectedSpace) => P36 (PreconnectedSpace) -/
theorem instPreconnectedSpaceOfSigmaConnectedSpace {X : Type u}
    [TopologicalSpace X] [SigmaConnectedSpace X] :
    PreconnectedSpace X := by infer_instance

end PiBase

namespace PiBase.Formal

theorem T484 : P189 ≤ P36 := fun X _ ↦ @instPreconnectedSpaceOfSigmaConnectedSpace X _

end PiBase.Formal
