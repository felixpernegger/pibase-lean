module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P34.Defs
public import PiBaseLean.Properties.P35.Defs

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

/-- Theorem T337: P35 (FullyT4Space) => P34 (FullyNormalSpace) -/
theorem instFullyNormalSpaceOfFullyT4Space (X : Type u)
    [TopologicalSpace X] [FullyT4Space X] :
    FullyNormalSpace X := by tauto

end PiBase

namespace PiBase.Formal

theorem T337 : P35 ≤ P34 := fun X _ ↦ @instFullyNormalSpaceOfFullyT4Space X _

end PiBase.Formal
