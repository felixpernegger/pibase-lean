module

public import Mathlib.Topology.MetricSpace.Defs
public import Mathlib.Topology.MetricSpace.Ultra.Basic
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

namespace PiBase

/- 220. Ultrametrizable -/
class UltraMetrizableSpace (X : Type*) [τ : TopologicalSpace X] : Prop where
  ex_ultrametric : ∃ (t : MetricSpace X),
    IsUltrametricDist X ∧ t.toUniformSpace.toTopologicalSpace = τ

end PiBase

namespace PiBase.Formal

def P220 : Property where
  toPred := UltraMetrizableSpace
  well_defined φ h := sorry

end PiBase.Formal
