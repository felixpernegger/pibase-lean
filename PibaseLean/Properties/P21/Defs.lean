import Mathlib

open Topology Set Function Filter

namespace PiBase

/- 21. Weakly countably compact -/
class WeaklyCountablyCompact (X : Type*) [TopologicalSpace X] : Prop where
  weakly_countably_compact : ∀ Y : Set X, Y.Infinite → ∃ x : X, AccPt x (𝓟 Y)

end PiBase
