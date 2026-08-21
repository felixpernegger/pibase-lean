module

public import PiBaseLean.Bundled.Basic
public import PiBaseLean.Properties.P2.Bundled
public import PiBaseLean.Properties.P3.Bundled

@[expose] public section

universe u

namespace PiBase

-- Most likely redundant
/-- Theorem T118: P3 (T2Space) => P2 (T1Space) -/
theorem instT1SpaceOfT2Space {X : Type u}
    [TopologicalSpace X] [T2Space X] :
    T1Space X := by infer_instance

end PiBase

namespace PiBase.Formal

theorem T118 : P3 ≤ P2 := fun X _ ↦ @instT1SpaceOfT2Space X _

end PiBase.Formal
