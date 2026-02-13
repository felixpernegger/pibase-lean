import Mathlib
import PibaseLean.Properties.P16.Formal
import PibaseLean.Properties.P19.Formal

open Topology Set Function TopologicalSpace

namespace PiBase

/- Theorem 1, compact implies compactly compact -/
instance CompactSpace.CountablyCompactSpace
    (X : Type*) [TopologicalSpace X] [h : CompactSpace X] :
    CountablyCompactSpace X where
  countablyCompact := by
    intro ι U hU uU
    #check isCompact_univ (X := X)
    #check (isCompact_iff_finite_subcover _).2 (isCompact_univ (X := X))
    sorry

end PiBase
