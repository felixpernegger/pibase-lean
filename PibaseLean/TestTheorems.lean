import Mathlib
import PibaseLean.Properties

namespace PiBase

/-- Some basic tests, best to ignore. -/

open Topology TopologicalSpace

universe u

variable {X : Type*} [TopologicalSpace X]

#check T2Space.t1Space

instance test [T2Space X] : T1Space X := by
  exact instT1SpaceOfT0SpaceOfR0Space

/-- Theorem 1 -/
instance (priority := 100) CountablyCompactSpace.CompactSpace [CountablyCompactSpace X] : CompactSpace X where
  isCompact_univ := by
    apply isCompact_iff_finite_subcover.2
    intro ι U h h'
    rename_i a b
    have := CountablyCompactSpace.countablyCompact X
    sorry



end PiBase
