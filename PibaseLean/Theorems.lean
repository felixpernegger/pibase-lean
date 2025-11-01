import Mathlib
import PibaseLean.Properties

namespace PiBase



open Topology TopologicalSpace

universe u

variable {X : Type*} [TopologicalSpace X]

#check T2Space.t1Space

/-- Theorem 1 -/
instance (priority := 100) CountablyCompactSpace.CompactSpace [CountablyCompactSpace X] : CompactSpace X where
  isCompact_univ := by
    apply isCompact_iff_finite_subcover.2
    intro ι U h h'

    sorry



end PiBase
