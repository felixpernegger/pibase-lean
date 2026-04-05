import Mathlib.Data.Finite.Defs
import Mathlib.Topology.Defs.Filter

open Set

namespace PiBase

/- 136. Anticompact -/
class AnticompactSpace (X : Type*) [TopologicalSpace X] : Prop where
  compact_finite (s : Set X) : IsCompact s → s.Finite

end PiBase
