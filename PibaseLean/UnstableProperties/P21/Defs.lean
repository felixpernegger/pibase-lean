import Mathlib

open Topology Set Function Filter

namespace UnstablePiBase

/- 21. Weakly countably compact -/
class WeaklyCountablyCompact (X : Type*) [TopologicalSpace X] : Prop where
  weakly_countably_compact : ∀ Y : Set X, Y.Infinite → ∃ x : X, AccPt x (𝓟 s)

end UnstablePiBase
