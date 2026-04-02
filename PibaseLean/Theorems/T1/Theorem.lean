import PibaseLean.Properties.P16.Formal
import PibaseLean.Properties.P19.Formal

open Topology Set Function TopologicalSpace

namespace PiBase

-- Note: Is merged in mathlib
/- Theorem 1, compact implies compactly compact -/
instance CompactSpace.CountablyCompactSpace
    {X : Type*} [TopologicalSpace X] [h : CompactSpace X] :
    CountablyCompactSpace X where
  isCountablyCompact_univ := isCompact_univ.isCountablyCompact


end PiBase
