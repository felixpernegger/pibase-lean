module

public import PiBaseLean.AdditionalDefs.Meta

@[expose] public section

namespace PiBase

/- 86. Homogeneous -/
class HomogeneousSpace (X : Type*) [TopologicalSpace X] : Prop where
  homogeneous : ∀ (x y : X), ∃ f : X ≃ₜ X, f x = y

end PiBase
