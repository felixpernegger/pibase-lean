module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P13.Defs
public import PiBaseLean.Properties.P57.Defs
public import PiBaseLean.Properties.P165.Defs

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

/-- Theorem T406: P165 (PseudonormalSpace) + P57 (Countable) => P13 (NormalSpace) -/
instance instNormalSpaceOfPseudonormalSpaceOfCountable (X : Type u)
    [TopologicalSpace X] [h : PseudonormalSpace X] [h' : Countable X] :
    NormalSpace X where
  normal s t hs ht st := h.pseudonormal s t (to_countable s) hs ht st

end PiBase

namespace PiBase.Formal

theorem T406 : P165 ⊓ P57 ≤ P13 := fun X _ ↦ and_imp.2 (@instNormalSpaceOfPseudonormalSpaceOfCountable X _)

end PiBase.Formal
