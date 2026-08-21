module

public import PiBaseLean.AdditionalDefs.Meta

@[expose] public section

universe u

namespace PiBase

/- 243. Has countable π-weight -/
class HasCountablePiWeight (X : Type u) [TopologicalSpace X] : Prop where
  countable_pi_base : ∃ s : Set (Set X), s.Countable ∧ IsPiBase s

end PiBase
