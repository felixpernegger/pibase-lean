module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P15.Defs
public import PiBaseLean.Properties.P132.Defs

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

/-- Theorem T256: P15 (PerfectlyNormalSpace) => P132 (GδSpace) -/
instance instGδSpaceOfPerfectlyNormalSpace (X : Type u)
    [TopologicalSpace X] [h : PerfectlyNormalSpace X] :
    GδSpace X where
  closed_gdelta := h.closed_gdelta

end PiBase

namespace PiBase.Formal

theorem T256 : P15 ≤ P132 := fun X _ ↦ @instGδSpaceOfPerfectlyNormalSpace X _

end PiBase.Formal
