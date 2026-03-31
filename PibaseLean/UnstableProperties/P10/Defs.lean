import Mathlib

open Topology Set Function TopologicalSpace

namespace UnstablePiBase

/- 10. Semiregular -/
class SemiregularSpace (X : Type*) [TopologicalSpace X] : Prop where
  semiregular : ∃ B : Set (Set X), IsTopologicalBasis B ∧ ∀ s ∈ B, interior (closure s) = s

end UnstablePiBase
