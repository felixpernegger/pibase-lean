module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P2.Defs
public import PiBaseLean.Properties.P15.Defs
public import PiBaseLean.Properties.P67.Defs

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

/-- Theorem T153: P2 (T1Space) + P15 (PerfectlyNormalSpace) => P67 (T6Space) -/
theorem instT6SpaceOfT1SpaceOfPerfectlyNormalSpace (X : Type u)
    [TopologicalSpace X] [T1Space X] [PerfectlyNormalSpace X] :
    T6Space X := by tauto

end PiBase

namespace PiBase.Formal

theorem T153 : P2 ⊓ P15 ≤ P67 := fun X _ ↦ and_imp.2 (@instT6SpaceOfT1SpaceOfPerfectlyNormalSpace X _)

end PiBase.Formal
