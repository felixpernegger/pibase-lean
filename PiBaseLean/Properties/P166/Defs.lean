module

public import Mathlib.Topology.MetricSpace.Basic

@[expose] public section

open Topology Set Filter TopologicalSpace

universe u v

namespace PiBase

/- 166. Has a coarser separable metrizable topology -/
class HasCoarserSeparableMetrizableTopology (X : Type u) [τ : TopologicalSpace X] : Prop where
  ex_coarser_metrizable_separable : ∃ m : MetricSpace X,
    τ ≤ m.toUniformSpace.toTopologicalSpace ∧ @SeparableSpace X m.toUniformSpace.toTopologicalSpace

end PiBase
