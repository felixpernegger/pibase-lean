module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P13.Defs
public import PiBaseLean.Properties.P15.Defs
public import PiBaseLean.Properties.P132.Defs

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

/-- Theorem T257: P13 (NormalSpace) + P132 (GδSpace) => P15 (PerfectlyNormalSpace) -/
instance instPerfectlyNormalSpaceOfNormalSpaceOfGδSpace (X : Type u)
    [TopologicalSpace X] [NormalSpace X] [h' : GδSpace X] :
    PerfectlyNormalSpace X where
  closed_gdelta := h'.closed_gdelta

end PiBase

namespace PiBase.Formal

theorem T257 : P13 ⊓ P132 ≤ P15 := fun X _ ↦ and_imp.2 (@instPerfectlyNormalSpaceOfNormalSpaceOfGδSpace X _)

end PiBase.Formal
