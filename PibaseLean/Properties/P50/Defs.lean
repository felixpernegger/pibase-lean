import Mathlib.Topology.Bases

open Topology Set Function Filter TopologicalSpace

namespace PiBase

/- 50. Zero dimensional -/
class ZeroDimensionalSpace (X : Type*) [TopologicalSpace X] : Prop where
  zero_dimensional : ∃ B : Set (Set X), IsTopologicalBasis B ∧ ∀ s ∈ B, IsClopen s

end PiBase
