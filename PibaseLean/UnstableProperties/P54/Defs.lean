import Mathlib

open Topology Set Function Filter TopologicalSpace

namespace UnstablePiBase

/- 54. Has a σ-locally finite base -/
class HasSigmaLocallyFiniteBase (X : Type*) [TopologicalSpace X] : Prop where
  has_sigma_locally_finite_base : ∃ B : Set (Set X), IsTopologicalBasis B ∧ ∀ s ∈ B, IsClopen s

end UnstablePiBase
