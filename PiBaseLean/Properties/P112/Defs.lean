import Mathlib.Topology.MetricSpace.Defs
import PiBaseLean.Properties.Bundled.Defs

open Topology Set TopologicalSpace

namespace PiBase

/- 112. Submetrizable space -/
class SubmetrizableSpace (X : Type*) [τ : TopologicalSpace X] : Prop where
  le_metrizable : ∃ m : MetricSpace X, τ ≤ m.toUniformSpace.toTopologicalSpace

end PiBase

namespace PiBase.Formal

def P112 : Property where
  toPred := SubmetrizableSpace
  well_defined φ h := sorry

end PiBase.Formal
