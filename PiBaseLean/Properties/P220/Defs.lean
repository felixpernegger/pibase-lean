import Mathlib.Topology.MetricSpace.Defs
import Mathlib.Topology.MetricSpace.Ultra.Basic

namespace PiBase

/- 220. Ultrametrizable -/
class UltraMetrizableSpace (X : Type*) [τ : TopologicalSpace X] : Prop where
  ex_ultrametric : ∃ (t : MetricSpace X),
    IsUltrametricDist X ∧ t.toUniformSpace.toTopologicalSpace = τ

end PiBase
