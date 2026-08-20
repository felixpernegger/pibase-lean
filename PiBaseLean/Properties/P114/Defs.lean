module

public import Mathlib.SetTheory.Cardinal.Aleph

@[expose] public section

open Cardinal

namespace PiBase

/- 114. Cardinality = ℵ₁ -/
class CardEqAlephOne (X : Type*) where
  card_eq : #X = ℵ₁

end PiBase
