import Mathlib.Topology.MetricSpace.Pseudo.Defs
import PiBaseLean.Properties.Bundled.Defs

open Topology Set Function

namespace PiBase

/- 22. PseudocompactSpace -/
class PseudocompactSpace (X : Type*) [TopologicalSpace X] : Prop where
  pseudocompact : ∀ (f : X → ℝ), Continuous f → BddBelow (range f) ∧ BddAbove (range f)

end PiBase

namespace PiBase.Formal

def P22 : Property where
  toPred := PseudocompactSpace
  well_defined φ h := sorry

end PiBase.Formal
