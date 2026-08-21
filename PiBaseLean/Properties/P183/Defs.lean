module

public import PiBaseLean.AdditionalDefs.Cover

@[expose] public section

universe u

namespace PiBase

/- 183. Has a countable k-network -/
class HasCountableKNetwork (X : Type u) [TopologicalSpace X] : Prop where
  ex_network : ∃ (ι : Type) (f : ι → Set X), Countable ι ∧ IsKNetwork f

end PiBase
