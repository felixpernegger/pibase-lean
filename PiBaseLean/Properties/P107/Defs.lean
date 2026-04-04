import Mathlib.Topology.Defs.Basic

open Topology Set Function TopologicalSpace

namespace PiBase

/- 107. Has a closed point -/
class HasClosedPoint (X : Type*) [TopologicalSpace X] : Prop where
  has_closed_point : ∃ x : X, IsClosed {x}

end PiBase

namespace PiBase.Formal

abbrev P107 := HasClosedPoint

class NP107 (X : Type*) [TopologicalSpace X] where
  not_p107 : ¬ P107 X

end PiBase.Formal
