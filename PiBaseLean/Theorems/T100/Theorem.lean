module

public import PiBaseLean.Bundled.Basic
public import PiBaseLean.Properties.P2.Bundled
public import PiBaseLean.Properties.P8.Bundled

@[expose] public section

universe u

namespace PiBase

-- Most likely redundant
/-- Theorem T100: P8 (T5Space) => P2 (T1Space) -/
theorem instT1SpaceOfT5Space {X : Type u}
    [TopologicalSpace X] [T5Space X] :
    T1Space X := by infer_instance

end PiBase

namespace PiBase.Formal

theorem T100 : P8 ≤ P2 := fun X _ ↦ @instT1SpaceOfT5Space X _

end PiBase.Formal
