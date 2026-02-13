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
    obtain ⟨t, ht⟩ := (isCompact_iff_finite_subcover).1 (isCompact_univ (X := X)) U hU
      (univ_subset_iff.mpr (id (Eq.symm uU)))
    use t
    constructor
    · exact Finset.countable_toSet t
    · exact ht

end PiBase
