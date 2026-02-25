import Mathlib

open Topology Set Function Filter TopologicalSpace

namespace PiBase

/- 89. Fixed point property -/
class FixedPointSpace (X : Type*) [TopologicalSpace X] : Prop where
  fixed_point : ∀ (f : X → X), Continuous f → ∃ x : X, f x = x

end PiBase
