module

public import Mathlib.Topology.MetricSpace.Pseudo.Defs

@[expose] public section

namespace PiBase

/- 60. Strongly connected -/
class StronglyConnectedSpace (X : Type*) [TopologicalSpace X] : Prop where
  strongly_connected : ∀ f : X → ℝ, Continuous f → ∃ r : ℝ, f = Function.const X r

end PiBase
