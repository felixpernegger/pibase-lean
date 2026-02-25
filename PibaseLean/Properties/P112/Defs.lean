import Mathlib

open Topology Set Function Filter TopologicalSpace Cardinal

namespace PiBase

/- 112. Toronto -/
class TorontoSpace (X : Type*) [TopologicalSpace X] where
  toronto : ∀ Y : Set X, #Y = #X → Y ≃ₜ X

end PiBase
