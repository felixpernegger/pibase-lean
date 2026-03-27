import Mathlib

open Topology Set Function Filter TopologicalSpace

namespace UnstablePiBase

/- 51. Scattered -/
class ScatteredSpace (X : Type*) [TopologicalSpace X] : Prop where
  scattered : ∀ Y : Set X, Y.Nonempty → ∃ x : Y, IsOpen {x}

end UnstablePiBase
