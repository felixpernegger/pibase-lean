import Mathlib.SetTheory.Cardinal.Continuum

open Cardinal

namespace PiBase

/- 65. Cardinality = 𝔠 -/
class CardEqContinuum (X : Type*) where
  card_eq : #X = 𝔠

end PiBase
