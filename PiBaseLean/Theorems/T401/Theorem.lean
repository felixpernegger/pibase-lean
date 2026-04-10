module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P13.Defs
public import PiBaseLean.Properties.P165.Defs

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

/-- Theorem T401: P13 (NormalSpace) => P165 (PseudonormalSpace) -/
instance instPseudonormalSpaceOfNormalSpace (X : Type u)
    [TopologicalSpace X] [h : NormalSpace X] :
    PseudonormalSpace X where
  pseudonormal _ _ _ hs ht st := normal_separation hs ht st

end PiBase

namespace PiBase.Formal

theorem T401 : P13 ≤ P165 := fun X _ ↦ @instPseudonormalSpaceOfNormalSpace X _

end PiBase.Formal
