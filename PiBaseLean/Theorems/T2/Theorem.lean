module

public import PiBaseLean.Bundled.Basic
public import PiBaseLean.Properties.P19.Bundled
public import PiBaseLean.Properties.P21.Bundled

@[expose] public section

universe u

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
