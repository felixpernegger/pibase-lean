module

public import PiBaseLean.Bundled.Basic
public import PiBaseLean.Properties.P14.Bundled
public import PiBaseLean.Properties.P8.Bundled

@[expose] public section

universe u

namespace PiBase

/-- Theorem T336: P8 (T5Space) => P14 (CompletelyNormalSpace) -/
theorem instCompletelyNormalSpaceOfT5Space {X : Type u}
    [TopologicalSpace X] [T5Space X] :
    CompletelyNormalSpace X := by infer_instance

end PiBase

namespace PiBase.Formal

theorem T336 : P8 ≤ P14 := fun X _ ↦ @instCompletelyNormalSpaceOfT5Space X _

end PiBase.Formal
