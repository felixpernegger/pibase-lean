module

public import PiBaseLean.Properties.Bundled.Basic
public import PiBaseLean.Properties.P19.Defs
public import PiBaseLean.Properties.P20.Defs

@[expose] public section

universe u

open Topology Set Function

namespace PiBase

/-- Theorem T3: P20 (Sequentially compact) => P19 (Countably compact)
--This is in mathlib (but not in stable version). -/
instance instSeqCompactSpaceCountablyCompactSpace
    {X : Type*} [TopologicalSpace X] [SeqCompactSpace X] : CountablyCompactSpace X where
  isCountablyCompact_univ := isSeqCompact_univ.isCountablyCompact

end PiBase

namespace PiBase.Formal

theorem T3 : P20 ≤ P19 := fun X _ ↦ @instSeqCompactSpaceCountablyCompactSpace X _

end PiBase.Formal
