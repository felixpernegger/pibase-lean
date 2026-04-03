import Mathlib.SetTheory.Cardinal.Continuum

open Cardinal

namespace PiBase

/- 65. Cardinality = 𝔠 -/
class CardEqContinuum (X : Type*) where
  card_eq : #X = 𝔠

end PiBase

namespace PiBase.Formal

abbrev P65 := CardEqContinuum

class NP65 (X : Type*) where
  not_p65 : ¬ P65 X

end PiBase.Formal
