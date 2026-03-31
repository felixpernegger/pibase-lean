import Mathlib

open Topology Set Function Filter TopologicalSpace

namespace UnstablePiBase

universe u

/- 99. US -/
class UsSpace (X : Type u) [TopologicalSpace X] : Prop where
  us : ∀ (f : ℕ → X) (a b : X), Tendsto f atTop (𝓝 a) → Tendsto f atTop (𝓝 b) → a = b

end UnstablePiBase
