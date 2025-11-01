import Mathlib
import PibaseLean.Properties

namespace PiBase



open Topology TopologicalSpace

universe u

variable {X : Type*}[TopologicalSpace X]

#check T2Space.t1Space

/-- Theorem 1 -/
instance (priority := 100) CompactSpace.CountablyCompactSpace [CompactSpace X] : CountablyCompactSpace X :=
  sorry



end PiBase
