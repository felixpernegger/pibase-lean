import Mathlib

open Topology Set Function Filter TopologicalSpace

namespace UnstablePiBase

/- 56. Meager -/
class MeagreSpace (X : Type*) [TopologicalSpace X] : Prop where
  meagre : IsMeagre (univ (α := X))

end UnstablePiBase
