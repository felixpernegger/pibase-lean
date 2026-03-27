import Mathlib

open Topology Set Function Filter TopologicalSpace

namespace UnstablePiBase

/- 60. Strongly connected -/
class StronglyConnectedSpace (X : Type*) [TopologicalSpace X] : Prop where
  strongly_connected : ∀ f : X → ℝ, Continuous f → ∃ r : ℝ, f = Function.const X r

end UnstablePiBase
