module

public import Mathlib.Topology.Defs.Basic

@[expose] public section

namespace PiBase

/-- 139. Has an isolated point -/
class HasAnIsolatedPoint (X : Type*) [TopologicalSpace X] : Prop where
  ex_isolated : ∃ x : X, IsOpen {x}

end PiBase
