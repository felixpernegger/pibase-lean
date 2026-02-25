import Mathlib

open Topology Set Function Filter TopologicalSpace

namespace PiBase

/- 99. US -/
class UsSpace (X : Type*) [TopologicalSpace X] : Prop where
  us : ∀ {Y : Type*} (f : Y → X) (l : Filter Y) (a b : X), NeBot l
    → Tendsto f l (𝓝 a) → Tendsto f l (𝓝 b) → a = b

end PiBase
