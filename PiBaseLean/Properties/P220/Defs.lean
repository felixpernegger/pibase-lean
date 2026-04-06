import Mathlib.Topology.MetricSpace.Defs
import Mathlib.Topology.MetricSpace.Ultra.Basic
import PiBaseLean.Properties.Bundled.Defs

namespace PiBase

/- 220. Ultrametrizable -/
class UltraMetrizableSpace (X : Type*) [τ : TopologicalSpace X] : Prop where
  ex_ultrametric : ∃ (t : MetricSpace X),
    IsUltrametricDist X ∧ t.toUniformSpace.toTopologicalSpace = τ

end PiBase

namespace PiBase.Formal

def P220 : Property where
  toPred := UltraMetrizableSpace
  well_defined' φ h := sorry

end PiBase.Formal
