import Mathlib.Topology.Defs.Basic

universe u

namespace PiBase

/-- 139. Has an isolated point -/
class HasAnIsolatedPoint (X : Type u) [TopologicalSpace X] : Prop where
  ex_isolated : ∃ x : X, IsOpen {x}

end PiBase
