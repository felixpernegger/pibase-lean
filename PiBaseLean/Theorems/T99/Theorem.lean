module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P2.Defs
public import PiBaseLean.Properties.P7.Defs
public import PiBaseLean.Properties.P13.Defs

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

/-- Theorem T99: P2 (T1Space) + P13 (NormalSpace) => P7 (T4Space) -/
theorem instT4SpaceOfT1SpaceOfNormalSpace (X : Type u)
    [TopologicalSpace X] [T1Space X] [NormalSpace X] :
    T4Space X := by tauto

end PiBase

namespace PiBase.Formal

theorem T99 : P2 ⊓ P13 ≤ P7 := fun X _ ↦ and_imp.2 (@instT4SpaceOfT1SpaceOfNormalSpace X _)

end PiBase.Formal
