import Mathlib.Topology.MetricSpace.Defs

open Topology Set TopologicalSpace

universe u

namespace PiBase

/- 112. Submetrizable space -/
class SubmetrizableSpace (X : Type u) [τ : TopologicalSpace X] : Prop where
  le_metrizable : ∃ m : MetricSpace X, m.toUniformSpace.toTopologicalSpace ≥ τ

end PiBase
