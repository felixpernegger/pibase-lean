module

public import PiBaseLean.AdditionalDefs.Cover

@[expose] public section

universe u

namespace PiBase

/- 182. Has a countable network -/ --NOTE: We use `Type` instead of `Type u` to be able to use `ℕ`
class HasCountableNetwork (X : Type u) [TopologicalSpace X] : Prop where
  has_countable_network : ∃ (ι : Type) (f : ι → Set X), Countable ι ∧ IsNetwork f

end PiBase
