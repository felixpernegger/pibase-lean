import Mathlib
import PibaseLean.UnstableProperties.P16.Formal
import PibaseLean.UnstableProperties.P19.Formal

open Topology Set Function TopologicalSpace

namespace UnstablePiBase

/- Theorem 1, compact implies compactly compact -/
instance CompactSpace.CountablyCompactSpace
    {X : Type*} [TopologicalSpace X] [h : CompactSpace X] :
    CountablyCompactSpace X where
  isCountablyCompact_univ := isCompact_univ.isCountablyCompact

end UnstablePiBase
