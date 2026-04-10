module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P5.Defs
public import PiBaseLean.Properties.P113.Defs

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

/-- Theorem T716: P113 (MooreSpace) => P5 (T3Space) -/
theorem instT3SpaceOfMooreSpace (X : Type u)
    [TopologicalSpace X] [MooreSpace X] :
    T3Space X := by tauto

end PiBase

namespace PiBase.Formal

theorem T716 : P113 ≤ P5 := fun X _ ↦ @instT3SpaceOfMooreSpace X _

end PiBase.Formal
