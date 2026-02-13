import Mathlib

open Topology Set Function

namespace PiBase

/- 22. Pseudocompact -/
class Pseudocompact (X : Type*) [TopologicalSpace X] : Prop where
  pseudocompact : ∀ (f : X → ℝ), Continuous f → Bornology.IsBounded (range f)

end PiBase
