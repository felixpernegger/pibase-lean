module

public import PiBaseLean.Bundled.Basic
public import PiBaseLean.Properties.P13.Bundled
public import PiBaseLean.Properties.P2.Bundled
public import PiBaseLean.Properties.P7.Bundled

@[expose] public section

universe u

namespace PiBase

/-- Theorem T99: P2 (T1Space) + P13 (NormalSpace) => P7 (T4Space) -/
theorem instT4SpaceOfT1SpaceOfNormalSpace {X : Type u}
    [TopologicalSpace X] [T1Space X] [NormalSpace X] :
    T4Space X := by tauto

end PiBase

namespace PiBase.Formal

theorem T99 : P2 ⊓ P13 ≤ P7 := fun X _ ↦ and_imp.2 (@instT4SpaceOfT1SpaceOfNormalSpace X _)

end PiBase.Formal
