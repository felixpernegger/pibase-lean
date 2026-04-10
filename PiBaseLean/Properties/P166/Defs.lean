module

public import Mathlib.Topology.MetricSpace.Basic
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

open Topology Set Filter TopologicalSpace

universe u

namespace PiBase

/- 166. Has a coarser separable metrizable topology -/
class HasCoarseSepsrableMetrizableTopology (X : Type u) [τ : TopologicalSpace X] : Prop where
  ex_coarser_metrizable_separable : ∃ m : MetricSpace X,
    τ ≤ m.toUniformSpace.toTopologicalSpace ∧ @SeparableSpace X m.toUniformSpace.toTopologicalSpace

end PiBase

namespace PiBase.Formal

def P166 : Property where
  toPred := HasCoarseSepsrableMetrizableTopology
  well_defined φ h := sorry

end PiBase.Formal
