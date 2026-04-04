import Mathlib.Topology.Defs.Induced

open Topology Set Function Filter TopologicalSpace

namespace PiBase

/- 51. Scattered -/
class ScatteredSpace (X : Type*) [TopologicalSpace X] : Prop where
  scattered : ∀ Y : Set X, Y.Nonempty → ∃ x : Y, IsOpen {x}

end PiBase
