import Mathlib.Topology.MetricSpace.Pseudo.Defs

open Topology Set Function Filter TopologicalSpace

namespace PiBase

/- 60. Strongly connected -/
class StronglyConnectedSpace (X : Type*) [TopologicalSpace X] : Prop where
  strongly_connected : ∀ f : X → ℝ, Continuous f → ∃ r : ℝ, f = Function.const X r

end PiBase
