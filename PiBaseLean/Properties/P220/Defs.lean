import Mathlib.Topology.MetricSpace.Ultra.Basic

universe u

namespace PiBase

/- 220. Ultrametrizable -/
class UltraMetrizableSpace (X : Type u) [τ : TopologicalSpace X] : Prop where
  ex_ultrametric : ∃ (t : PseudoMetricSpace X),
    IsUltrametricDist X ∧ t.toUniformSpace.toTopologicalSpace = τ

end PiBase
