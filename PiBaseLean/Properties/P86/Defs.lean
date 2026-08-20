module

public import PiBaseLean.AdditionalDefs.Meta

@[expose] public section

open Topology Set Function Filter TopologicalSpace

namespace PiBase

/- 86. Homogeneous -/
class HomogeneousSpace (X : Type*) [TopologicalSpace X] : Prop where
  homogeneous : ∀ (x y : X), ∃ f : X ≃ₜ X, f x = y

end PiBase
