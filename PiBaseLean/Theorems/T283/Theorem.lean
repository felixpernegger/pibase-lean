module

public import PiBaseLean.Bundled.Basic
public import PiBaseLean.Properties.P1.Bundled
public import PiBaseLean.Properties.P134.Bundled
public import PiBaseLean.Properties.P3.Bundled

@[expose] public section

universe u

namespace PiBase

/-- Theorem T283: P134 (R1Space) + P1 (T0Space) => P3 (T2Space) -/
theorem instT2SpaceOfR1SpaceOfT0Space {X : Type u}
    [TopologicalSpace X] [R1Space X] [T0Space X] :
    T2Space X := by infer_instance

end PiBase

namespace PiBase.Formal

theorem T283 : P134 ⊓ P1 ≤ P3 := fun X _ ↦ and_imp.2 (@instT2SpaceOfR1SpaceOfT0Space X _)

end PiBase.Formal
