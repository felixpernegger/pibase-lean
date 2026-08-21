module

public import Mathlib.Topology.GDelta.Basic

@[expose] public section

open Set

namespace PiBase

/- 56. Meager -/
class MeagreSpace (X : Type*) [TopologicalSpace X] : Prop where
  meagre : IsMeagre (univ (α := X))

end PiBase
