import Mathlib.Topology.MetricSpace.Defs

open Topology Set TopologicalSpace

namespace PiBase

/- 112. Submetrizable space -/
class SubmetrizableSpace (X : Type*) [τ : TopologicalSpace X] : Prop where
  le_metrizable : ∃ m : MetricSpace X, τ ≤ m.toUniformSpace.toTopologicalSpace

end PiBase
