module

public import Mathlib.Topology.Homeomorph.Lemmas

@[expose] public section

universe u

namespace PiBase

/- 170. k₁-Hausdorff -/
class K1T2Space (X : Type u) [TopologicalSpace X] : Prop where
  compact_t2 (s : Set X) : IsCompact s → T2Space s

end PiBase
