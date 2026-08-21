module

public import Mathlib.Topology.Homeomorph.Lemmas

@[expose] public section

namespace PiBase

/- 136. Anticompact -/
class AnticompactSpace (X : Type*) [TopologicalSpace X] : Prop where
  compact_finite (s : Set X) : IsCompact s → s.Finite

end PiBase
