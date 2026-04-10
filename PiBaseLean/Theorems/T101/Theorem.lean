module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P2.Defs
public import PiBaseLean.Properties.P8.Defs
public import PiBaseLean.Properties.P14.Defs

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

/-- Theorem T101: P2 (T1Space) + P14 (CompletelyNormalSpace) => P8 (T5Space) -/
theorem instT5SpaceOfT1SpaceOfCompletelyNormalSpace (X : Type u)
    [TopologicalSpace X] [T1Space X] [CompletelyNormalSpace X] :
    T5Space X := by tauto

end PiBase

namespace PiBase.Formal

theorem T101 : P2 ⊓ P14 ≤ P8 := fun X _ ↦ and_imp.2 (@instT5SpaceOfT1SpaceOfCompletelyNormalSpace X _)

end PiBase.Formal
