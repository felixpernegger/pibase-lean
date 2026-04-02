import Mathlib.Topology.Defs.Basic

open Topology Set Function TopologicalSpace

namespace PiBase

/- 107. Has a closed point -/
class HasClosedPoint (X : Type*) [TopologicalSpace X] : Prop where
  has_closed_point : ∃ x : X, IsClosed {x}

end PiBase
