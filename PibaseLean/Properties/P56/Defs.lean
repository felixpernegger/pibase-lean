import Mathlib.Topology.GDelta.Basic

open Topology Set Function Filter TopologicalSpace

namespace PiBase

/- 56. Meager -/
class MeagreSpace (X : Type*) [TopologicalSpace X] : Prop where
  meagre : IsMeagre (univ (α := X))

end PiBase

namespace PiBase.Formal

abbrev P56 := MeagreSpace

class NP56 (X : Type*) [TopologicalSpace X] where
  not_p56 : ¬ P56 X

end PiBase.Formal
