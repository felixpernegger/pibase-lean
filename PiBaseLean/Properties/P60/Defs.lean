module

public import Mathlib.Topology.MetricSpace.Pseudo.Defs
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

open Topology Set Function Filter TopologicalSpace

namespace PiBase

/- 60. Strongly connected -/
class StronglyConnectedSpace (X : Type*) [TopologicalSpace X] : Prop where
  strongly_connected : ∀ f : X → ℝ, Continuous f → ∃ r : ℝ, f = Function.const X r

end PiBase

namespace PiBase.Formal

def P60 : Property where
  toPred := StronglyConnectedSpace
  well_defined φ h := sorry

end PiBase.Formal
