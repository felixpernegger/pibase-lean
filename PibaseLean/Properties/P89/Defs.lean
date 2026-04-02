import Mathlib.Topology.Defs.Basic

open Topology Set Function TopologicalSpace

namespace PiBase

/- 89. Fixed point property -/
class FixedPointSpace (X : Type*) [TopologicalSpace X] : Prop where
  fixed_point : ∀ (f : X → X), Continuous f → ∃ x : X, f x = x

end PiBase
