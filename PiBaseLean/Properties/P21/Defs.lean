module

public import Mathlib.Data.Finite.Defs
public import Mathlib.Topology.Defs.Filter

@[expose] public section

open Filter

universe u

namespace PiBase

/- 21. Weakly countably compact -/
class WeaklyCountablyCompact (X : Type*) [TopologicalSpace X] : Prop where
  weakly_countably_compact : ∀ s : Set X, s.Infinite → ∃ x : X, AccPt x (𝓟 s)

end PiBase
