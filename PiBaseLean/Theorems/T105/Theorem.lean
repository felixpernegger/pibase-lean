module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P2.Defs
public import PiBaseLean.Properties.P34.Defs
public import PiBaseLean.Properties.P35.Defs

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

/-- Theorem T105: P2 (T1Space) + P34 (FullyNormalSpace) => P35 (FullyT4Space) -/
theorem instFullyT4SpaceOfT1SpaceOfFullyNormalSpace (X : Type u)
    [TopologicalSpace X] [T1Space X] [FullyNormalSpace X] :
    FullyT4Space X := by tauto

end PiBase

namespace PiBase.Formal

theorem T105 : P2 ⊓ P34 ≤ P35 := fun X _ ↦ and_imp.2 (@instFullyT4SpaceOfT1SpaceOfFullyNormalSpace X _)

end PiBase.Formal
