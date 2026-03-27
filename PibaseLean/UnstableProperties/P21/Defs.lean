import Mathlib

open Topology Set Function

namespace UnstablePiBase

/- 21. Weakly countably compact -/
class WeaklyCountablyCompact (X : Type*) [TopologicalSpace X] : Prop where
  weakly_countably_compact : ∀ Y : Set X, ¬ Y.Finite → ∃ x : X, ∀ s ∈ 𝓝 x, (s ∩ Yᶜ).Finite

end UnstablePiBase
