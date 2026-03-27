import Mathlib

open Topology Set Function Filter TopologicalSpace

namespace UnstablePiBase

/- 50. Zero dimensional -/
class ZeroDimensionalSpace (X : Type*) [TopologicalSpace X] : Prop where
  zero_dimensional : ∃ B : Set (Set X), IsTopologicalBasis B ∧ ∀ s ∈ B, IsClopen s

end UnstablePiBase
