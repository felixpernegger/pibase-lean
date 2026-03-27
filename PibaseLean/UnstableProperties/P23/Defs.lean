import Mathlib

open Topology Set Function

namespace UnstablePiBase

/- 23. Weakly locally compact -/
class WeaklyLocallyCompact (X : Type*) [TopologicalSpace X] : Prop where
  weakly_locally_compact : ∀ (x : X), ∃ C ∈ 𝓝 x, IsCompact C

end UnstablePiBase
