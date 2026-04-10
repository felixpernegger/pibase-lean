module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P2.Defs
public import PiBaseLean.Properties.P132.Defs
public import PiBaseLean.Properties.P191.Defs

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

/-- Theorem T502: P132 (GδSpace) + P2 (T1Space) => P191 (HasGδSingletons) -/
instance instHasGδSingletonsOfGδSpaceOfT1Space (X : Type u)
    [TopologicalSpace X] [h : GδSpace X] [h' : T1Space X] :
    HasGδSingletons X where
  isGδ_singleton x := h.closed_gdelta <| T1Space.t1 x

end PiBase

namespace PiBase.Formal

theorem T502 : P132 ⊓ P2 ≤ P191 := fun X _ ↦ and_imp.2 (@instHasGδSingletonsOfGδSpaceOfT1Space X _)

end PiBase.Formal
