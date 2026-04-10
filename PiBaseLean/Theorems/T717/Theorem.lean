module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P5.Defs
public import PiBaseLean.Properties.P110.Defs
public import PiBaseLean.Properties.P113.Defs

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

/-- Theorem T717: P110 (DevelopableSpace) + P5 (T3Space) => P113 (MooreSpace) -/
theorem instMooreSpaceOfDevelopableSpaceOfT3Space (X : Type u)
    [TopologicalSpace X] [DevelopableSpace X] [T3Space X] :
    MooreSpace X := by tauto

end PiBase

namespace PiBase.Formal

theorem T717 : P110 ⊓ P5 ≤ P113 := fun X _ ↦ and_imp.2 (@instMooreSpaceOfDevelopableSpaceOfT3Space X _)

end PiBase.Formal
