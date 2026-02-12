import Mathlib

open Topology Set Function TopologicalSpace

namespace PiBase

/-- 10. Semiregular -/
class SemiregularSpace (X : Type u) [TopologicalSpace X] : Prop where
  semiregular : ∃ B : Set (Set X), IsTopologicalBasis B ∧ ∀ s ∈ B, interior (closure s) = s

end PiBase
