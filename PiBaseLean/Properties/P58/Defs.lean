module

public import Mathlib.SetTheory.Cardinal.Continuum

@[expose] public section

open Cardinal

namespace PiBase

/- 58. Cardinality < 𝔠 -/
class CardLtContinuum (X : Type*) where
  card_lt : #X < 𝔠

end PiBase
