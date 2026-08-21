module

public import PiBaseLean.AdditionalDefs.Constructions

@[expose] public section

namespace PiBase

/- 101. Has closed retracts -/
class HasClosedRetract (X : Type*) [TopologicalSpace X] : Prop where
  has_closed_retract : ∀ A : Set X, IsRetract A → IsClosed A

end PiBase
