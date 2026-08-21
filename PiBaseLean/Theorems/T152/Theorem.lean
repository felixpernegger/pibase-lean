module

public import PiBaseLean.Bundled.Basic
public import PiBaseLean.Properties.P2.Bundled
public import PiBaseLean.Properties.P67.Bundled

@[expose] public section

universe u

namespace PiBase

-- Most likely redundant
/-- Theorem T152: P67 (T6Space) => P2 (T1Space) -/
theorem instT1SpaceOfT6Space {X : Type u}
    [TopologicalSpace X] [T6Space X] :
    T1Space X := by infer_instance

end PiBase

namespace PiBase.Formal

theorem T152 : P67 ≤ P2 := fun X _ ↦ @instT1SpaceOfT6Space X _

end PiBase.Formal
