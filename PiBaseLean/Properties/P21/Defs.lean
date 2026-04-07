module

public import Mathlib.Data.Finite.Defs
public import Mathlib.Topology.Defs.Filter
public import PiBaseLean.Properties.Bundled.Defs

@[expose] public section

open Topology Set Filter

namespace PiBase

/- 21. Weakly countably compact -/
class WeaklyCountablyCompact (X : Type*) [TopologicalSpace X] : Prop where
  weakly_countably_compact : ∀ Y : Set X, Y.Infinite → ∃ x : X, AccPt x (𝓟 Y)

end PiBase

namespace PiBase.Formal

def P21 : Property where
  toPred := WeaklyCountablyCompact
  well_defined φ h := sorry

end PiBase.Formal
