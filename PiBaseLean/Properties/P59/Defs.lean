import Mathlib.SetTheory.Cardinal.Continuum

open Cardinal

namespace PiBase

/- 59. Cardinality < 2 ^ 𝔠 -/
class CardLtPowerContinuum (X : Type*) where
  card_lt : #X < 2 ^ 𝔠

end PiBase

namespace PiBase.Formal

abbrev P59 := CardLtPowerContinuum

class NP59 (X : Type*) where
  not_p59 : ¬ P59 X

end PiBase.Formal
