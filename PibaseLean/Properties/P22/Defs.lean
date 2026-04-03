import Mathlib.Topology.MetricSpace.Pseudo.Defs

open Topology Set Function

namespace PiBase

/- 22. PseudocompactSpace -/
class PseudocompactSpace (X : Type*) [TopologicalSpace X] : Prop where
  pseudocompact : ∀ (f : X → ℝ), Continuous f → BddBelow (range f) ∧ BddAbove (range f)

end PiBase
