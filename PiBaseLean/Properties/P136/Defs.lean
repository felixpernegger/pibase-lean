module

public import Mathlib.Data.Finite.Defs
public import Mathlib.Topology.Defs.Filter
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

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
