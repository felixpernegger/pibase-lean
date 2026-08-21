module

public import PiBaseLean.Bundled.Basic
public import PiBaseLean.Properties.P127.Bundled
public import PiBaseLean.Properties.P7.Bundled

@[expose] public section

universe u

namespace PiBase

/-- Theorem T157: P127 (DowkerSpace) => P7 (T4Space) -/
theorem instT4SpaceOfDowkerSpace {X : Type u}
    [TopologicalSpace X] [DowkerSpace X] :
    T4Space X := by tauto

end PiBase

namespace PiBase.Formal

theorem T157 : P127 ≤ P7 := fun X _ ↦ @instT4SpaceOfDowkerSpace X _

end PiBase.Formal
