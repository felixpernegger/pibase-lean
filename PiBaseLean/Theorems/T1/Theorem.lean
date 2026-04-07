import PiBaseLean.Properties.Bundled.Basic
import PiBaseLean.Properties.P16.Defs
import PiBaseLean.Properties.P19.Defs

open Topology Set Function TopologicalSpace

namespace PiBase

-- Note: Is merged in mathlib
/- Theorem 1, compact implies compactly compact -/
instance instCompactSpaceOfCountablyCompactSpace
    {X : Type*} [TopologicalSpace X] [h : CompactSpace X] :
    CountablyCompactSpace X where
  isCountablyCompact_univ := isCompact_univ.isCountablyCompact

end PiBase

namespace PiBase.Formal

theorem T1 : P16 ≤ P19 := @instCompactSpaceOfCountablyCompactSpace

end PiBase.Formal
