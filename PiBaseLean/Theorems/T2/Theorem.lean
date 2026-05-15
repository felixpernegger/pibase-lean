module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P19.Defs
public import PiBaseLean.Properties.P21.Defs

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

/-- Theorem T2: P19 (Countably compact) => P21 (Weakly countably compact) -/
instance instWeaklyCountablyCompactOfCountablyCompactSpace
    {X : Type*} [TopologicalSpace X] [hX : CountablyCompactSpace X] : WeaklyCountablyCompact X where
  weakly_countably_compact := fun _ ↦ by
    simpa using hX.isCountablyCompact_univ.exists_accPt_of_infinite

end PiBase

namespace PiBase.Formal

theorem T2 : P19 ≤ P21 := fun X _ ↦ @instWeaklyCountablyCompactOfCountablyCompactSpace X _

end PiBase.Formal
