module

public import PiBaseLean.AdditionalDefs.Cardinal

@[expose] public section

open Topology Set Filter TopologicalSpace

universe u

namespace PiBase

/- 173. Pseudoradial -/
class PseudoradialSpace (X : Type u) [TopologicalSpace X] : Prop where
  radiallyClosed_isClosed : ∀ ⦃s : Set X⦄, IsRadiallyClosed s → IsClosed s

end PiBase
