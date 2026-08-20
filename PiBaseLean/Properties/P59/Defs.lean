module

public import Mathlib.SetTheory.Cardinal.Continuum

@[expose] public section

open Cardinal

namespace PiBase

/- 59. Cardinality ≤ 2 ^ 𝔠 -/
class CardLePowerContinuum (X : Type*) where
  card_le : #X ≤ 2 ^ 𝔠

end PiBase
