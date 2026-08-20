module

public import Mathlib.SetTheory.Cardinal.Continuum

@[expose] public section

open Cardinal

namespace PiBase

/- 65. Cardinality = 𝔠 -/
class CardEqContinuum (X : Type*) where
  card_eq : #X = 𝔠

end PiBase
