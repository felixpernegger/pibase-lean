module

public import PiBaseLean.Bundled.Basic
public import PiBaseLean.Properties.P1.Bundled
public import PiBaseLean.Properties.P135.Bundled
public import PiBaseLean.Properties.P2.Bundled

@[expose] public section

universe u

namespace PiBase

/-- Theorem T288: P135 (R0Space) + P1 (T0Space) => P2 (T1Space) -/
theorem instT1SpaceOfR0SpaceOfT0Space {X : Type u}
    [TopologicalSpace X] [R0Space X] [T0Space X] :
    T1Space X := by infer_instance

end PiBase

namespace PiBase.Formal

theorem T288 : P135 ⊓ P1 ≤ P2 := fun X _ ↦ and_imp.2 (@instT1SpaceOfR0SpaceOfT0Space X _)

end PiBase.Formal
