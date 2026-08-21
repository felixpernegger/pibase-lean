module

public import PiBaseLean.AdditionalDefs.Cardinal

@[expose] public section

universe u

namespace PiBase

/- 173. Pseudoradial -/
class PseudoradialSpace (X : Type u) [TopologicalSpace X] : Prop where
  radiallyClosed_isClosed : ∀ ⦃s : Set X⦄, IsRadiallyClosed s → IsClosed s

end PiBase
