import Mathlib.Topology.GDelta.Basic

open Topology Set Function Filter TopologicalSpace

namespace PiBase

/- 56. Meager -/
class MeagreSpace (X : Type*) [TopologicalSpace X] : Prop where
  meagre : IsMeagre (univ (α := X))

end PiBase
