import Mathlib

open Topology Set Function Filter TopologicalSpace

namespace UnstablePiBase

/- 46. Totally path disconnected -/
class TotallyPathDisconnectedSpace (X : Type*) [TopologicalSpace X] : Prop where
  totally_path_disconnected : ∀ f : Icc (0 : ℝ) 1 → X, Continuous f → ∃ x : X, f = const (Icc 0 1) x

end UnstablePiBase
