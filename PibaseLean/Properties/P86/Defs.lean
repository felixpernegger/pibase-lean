import Mathlib.Topology.Homeomorph.Defs

open Topology Set Function Filter TopologicalSpace

namespace PiBase

/- 86. Homogenous -/
class HomogenousSpace (X : Type*) [TopologicalSpace X] : Prop where
  homogenous : ∀ (x y : X), ∃ f : X ≃ₜ X, f x = y

end PiBase
