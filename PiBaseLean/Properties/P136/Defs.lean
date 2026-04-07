import Mathlib.Data.Finite.Defs
import Mathlib.Topology.Defs.Filter
import PiBaseLean.Properties.Bundled.Defs

open Set

namespace PiBase

/- 136. Anticompact -/
class AnticompactSpace (X : Type*) [TopologicalSpace X] : Prop where
  compact_finite (s : Set X) : IsCompact s → s.Finite

end PiBase

namespace PiBase.Formal

def P136 : Property where
  toPred := AnticompactSpace
  well_defined φ h := sorry

end PiBase.Formal
