module

public import Mathlib.Topology.Defs.Induced

@[expose] public section

namespace PiBase

/- 51. Scattered -/
class ScatteredSpace (X : Type*) [TopologicalSpace X] : Prop where
  scattered : ∀ s : Set X, s.Nonempty → ∃ x : s, IsOpen {x}

end PiBase
