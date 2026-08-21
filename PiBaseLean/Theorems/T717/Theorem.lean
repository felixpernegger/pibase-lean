module

public import PiBaseLean.Bundled.Basic
public import PiBaseLean.Properties.P110.Bundled
public import PiBaseLean.Properties.P113.Bundled
public import PiBaseLean.Properties.P5.Bundled

@[expose] public section

universe u

namespace PiBase

/-- Theorem T717: P110 (DevelopableSpace) + P5 (T3Space) => P113 (MooreSpace) -/
theorem instMooreSpaceOfDevelopableSpaceOfT3Space {X : Type u}
    [TopologicalSpace X] [DevelopableSpace X] [T3Space X] :
    MooreSpace X := by tauto

end PiBase

namespace PiBase.Formal

theorem T717 :
  P110 ⊓ P5 ≤ P113 := fun X _ ↦ and_imp.2 (@instMooreSpaceOfDevelopableSpaceOfT3Space X _)

end PiBase.Formal
