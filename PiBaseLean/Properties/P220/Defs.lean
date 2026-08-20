module

public import Mathlib.Topology.MetricSpace.Basic
public import Mathlib.Topology.MetricSpace.Ultra.Basic

@[expose] public section

universe u

namespace PiBase

/- 220. Ultrametrizable -/
class UltraMetrizableSpace (X : Type*) [τ : TopologicalSpace X] : Prop where
  ex_ultrametric : ∃ (t : MetricSpace X),
    IsUltrametricDist X ∧ t.toUniformSpace.toTopologicalSpace = τ

end PiBase
