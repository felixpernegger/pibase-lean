module

public import Mathlib.Data.Finite.Defs
public import Mathlib.Topology.Compactness.Compact
public import Mathlib.Topology.Homeomorph.Lemmas
public import Mathlib.Topology.Defs.Filter

@[expose] public section

open Set

namespace PiBase

/- 136. Anticompact -/
class AnticompactSpace (X : Type*) [TopologicalSpace X] : Prop where
  compact_finite (s : Set X) : IsCompact s → s.Finite

end PiBase
