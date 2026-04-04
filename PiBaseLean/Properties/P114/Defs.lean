import Mathlib.SetTheory.Cardinal.Aleph

open Cardinal
namespace PiBase

/- 58. Cardinality < 𝔠 -/
class CardEqAlephOne (X : Type*) where
  card_eq : #X = ℵ1

end PiBase
