import Mathlib.Topology.Bases
import PiBaseLean.Properties.Bundled.Defs

open Topology Set Function Filter TopologicalSpace

namespace PiBase

/- 50. Zero dimensional -/
class ZeroDimensionalSpace (X : Type*) [TopologicalSpace X] : Prop where
  zero_dimensional : ∃ B : Set (Set X), IsTopologicalBasis B ∧ ∀ s ∈ B, IsClopen s

end PiBase

namespace PiBase.Formal

def P50 : Property where
  toPred := ZeroDimensionalSpace
  well_defined' φ h := sorry

end PiBase.Formal
