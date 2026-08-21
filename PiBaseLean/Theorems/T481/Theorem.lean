module

public import PiBaseLean.Bundled.Basic
public import PiBaseLean.Properties.P188.Bundled
public import PiBaseLean.Properties.P3.Bundled

@[expose] public section

universe u

namespace PiBase

/-- Theorem T481: P188 (ContinuumSpace) => P3 (T2Space) -/
theorem instT2SpaceOfContinuumSpace {X : Type u}
    [TopologicalSpace X] [ContinuumSpace X] :
    T2Space X := by infer_instance

end PiBase

namespace PiBase.Formal

theorem T481 : P188 ≤ P3 := fun X _ ↦ @instT2SpaceOfContinuumSpace X _

end PiBase.Formal
