module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P119.Defs
public import PiBaseLean.Properties.P195.Defs

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

/-- Theorem T802: P119 (StoneanSpace) => P195 (StoneSpace) -/
theorem instStoneSpaceOfStoneanSpace (X : Type u)
    [TopologicalSpace X] [StoneanSpace X] :
    StoneSpace X := by tauto

end PiBase

namespace PiBase.Formal

theorem T802 : P119 ≤ P195 := fun X _ ↦ @instStoneSpaceOfStoneanSpace X _

end PiBase.Formal
