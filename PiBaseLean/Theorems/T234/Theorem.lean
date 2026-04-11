module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P100.Defs
public import PiBaseLean.Properties.P103.Defs

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

/-- Theorem T234: P103 (StronglyKcSpace) => P100 (KcSpace) -/
instance instKcSpaceOfStronglyKcSpace (X : Type u)
    [TopologicalSpace X] [h : StronglyKcSpace X] :
    KcSpace X where
  kc s hs := h.countablycompact_closed s hs.isCountablyCompact

end PiBase

namespace PiBase.Formal

theorem T234 : P103 ≤ P100 := fun X _ ↦ @instKcSpaceOfStronglyKcSpace X _

end PiBase.Formal
